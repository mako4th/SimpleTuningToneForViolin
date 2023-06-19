//
//  com.amakusaweb.FFTreturnArrays.m
//  OkabeFFTRefactor
//
//  Created by 岡部 誠 on 2014/09/01.
//  Copyright (c) 2014年 MAKOTO OKABE. All rights reserved.
//

#import "com.amakusaweb.fft.h"

@implementation com_amakusaweb_fft{
    //AudioUnit
    AudioUnit remoteIOUnit;
    
    //バッファサイズ等の計算
    double fftBuffaFrames,fftLog2Buffasize;
    Float32 *fftbuffa;
    
    long fftBuffaChankCount,fftBuffaChankLastNum,fftBuffaChankCounter,ChankSize,fftbuffaCopyAdr;
    
    double s_w_rate;
    
    //窓関数に使う配列
    Float32 *window,*windowedInput;
    
    //fftの準備
    FFTSetup fftSetUp;
    float *outputVector;
    DSPSplitComplex splitComplex;
    
    
    //結果保持
    float *resultArray;
    
    //FFT結果から最大５くらい取得
    float vdspc; //最大値
    vDSP_Length vdspci; //最大値のインデックス
    
    //基準となるsin波を生成しておく
    Float32 *referenceSineWave;
    
}

- (instancetype)initWithBuffaSizeLog2:(int)BuffasizeLog2 returnArray:(float*)returnArray
{
    self = [super init];
    if (self) {
        resultArray = returnArray;
        
        float mSampleRate = 44100.0; //44100.0
        

        [self AudioSessionSetup];
        [self FFTpreSetupBuffaSizeLog2:BuffasizeLog2 SampleRate:mSampleRate inNumberFrames:1024];  //2^14=16384  2^15=32768 2^16=65536 2^17=131072
        [self AudioUnitSetupSampleRate:mSampleRate];
    }
    return self;
}


static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp *inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData){
    
    com_amakusaweb_fft *bridgedInRef = (__bridge com_amakusaweb_fft *)inRef;

#pragma mark -inputRendering
    Float32 *inputL,*inputR;
    //Mic入力をioDataにレンダリングする
    AudioUnitRender(bridgedInRef->remoteIOUnit, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
    inputL = (Float32 *)ioData->mBuffers[0].mData;
    if(ioData->mNumberBuffers > 1){
        inputR = (Float32 *)ioData->mBuffers[1].mData;
    }else{
        inputR = (Float32 *)ioData->mBuffers[0].mData;
    }
#pragma mark -buffaling
    //レンダリング結果をバッファに保存
    memmove(bridgedInRef->fftbuffa, bridgedInRef->fftbuffa + 1024, bridgedInRef->fftBuffaFrames * sizeof(Float32) - bridgedInRef->ChankSize);
    memcpy(bridgedInRef->fftbuffa + bridgedInRef->fftbuffaCopyAdr, inputL, inNumberFrames * sizeof(Float32));
    //スピーカーから音が出ないようにする
    memset(inputL, 0, inNumberFrames * sizeof(Float32));
    memset(inputR, 0, inNumberFrames * sizeof(Float32));

    //referenceSineでテスト
    for (long i = 0; i <bridgedInRef->fftBuffaFrames; i++) {
        bridgedInRef->fftbuffa[i] = bridgedInRef->referenceSineWave[i];
    }
    
#pragma mark fftbuffaにwindow関数適用
    vDSP_vmul(bridgedInRef->fftbuffa, 1, bridgedInRef->window, 1, bridgedInRef->windowedInput, 1, bridgedInRef->fftBuffaFrames);
    
    //窓関数なし　（矩形窓）
//    memcpy(bridgedInRef->windowedInput, bridgedInRef->fftbuffa, bridgedInRef->fftBuffaFrames * sizeof(Float32));
    
    
    //レンダリング結果を複素数配列にコピー
    vDSP_ctoz((COMPLEX *)bridgedInRef->windowedInput, 1, &bridgedInRef->splitComplex,1 ,bridgedInRef->fftBuffaFrames);
    
    //FFT適用
    vDSP_fft_zrip(bridgedInRef->fftSetUp, &bridgedInRef->splitComplex, 1, bridgedInRef->fftLog2Buffasize + 1, FFT_FORWARD);
    
    //FFT結果のスカラ化
    vDSP_vdist(bridgedInRef->splitComplex.realp, 1, bridgedInRef->splitComplex.imagp, 1, bridgedInRef->outputVector, 1, bridgedInRef->fftBuffaFrames);
    
    
    //FFT結果から最大５くらい取得
    for (int i = 0; i < 5; i++) {
        vDSP_maxvi(bridgedInRef->outputVector, 1, &(bridgedInRef->vdspc), &(bridgedInRef->vdspci), (bridgedInRef->fftBuffaFrames) / 2);
        
        bridgedInRef->resultArray[i] = (int)bridgedInRef->vdspci;// * bridgedInRef->s_w_rate;
        bridgedInRef->outputVector[bridgedInRef->vdspci] = 0;
       // printf("max[%d]= %f\n",i,bridgedInRef->resultArray[i]*(bridgedInRef->s_w_rate));
    }
    
    
    return noErr;
}



-(void)AudioUnitSetupSampleRate:(float)SampleRate{
    
    //AudioUnitの初期化
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    
    AudioComponent ac = AudioComponentFindNext(NULL, &acd);
    AudioComponentInstanceNew(ac, &remoteIOUnit);
    
    // ここでコールバック時に実行するメソッドを指定
    AURenderCallbackStruct CallbackStruct;
    CallbackStruct.inputProc = renderer;
    CallbackStruct.inputProcRefCon = (__bridge void*)self;
    
    AudioUnitSetProperty(remoteIOUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &CallbackStruct, sizeof(AURenderCallbackStruct));
    
    
    // AudioStreamBasicDescription(ASBD)の設定
    AudioStreamBasicDescription asbd;
    asbd.mSampleRate = SampleRate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
    asbd.mChannelsPerFrame = 2;
    asbd.mBytesPerPacket = sizeof(AudioUnitSampleType);
    asbd.mBytesPerFrame = sizeof(AudioUnitSampleType);
    asbd.mFramesPerPacket = 1;
    asbd.mBitsPerChannel = 8 * sizeof(AudioUnitSampleType);
    asbd.mReserved = 0;
    
    AudioUnitSetProperty(remoteIOUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Output,
                         0,
                         &asbd,
                         sizeof(asbd));
    
    
    //マイク入力をオンにする
    UInt32 flag = 1;
    AudioUnitSetProperty(remoteIOUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         1,
                         &flag,
                         sizeof(UInt32));
    // 再生開始
    AudioUnitInitialize(remoteIOUnit);
    AudioOutputUnitStart(remoteIOUnit);
    
}



-(void)AudioSessionSetup{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioSession setActive:YES error:nil];
    
}

-(void)FFTpreSetupBuffaSizeLog2:(int)Log2BuffaSize SampleRate:(float)sf inNumberFrames:(int)inNumberFrames{
#pragma mark fft準備

    
    //バッファサイズ等の計
    fftLog2Buffasize = Log2BuffaSize;
    fftBuffaFrames = pow(2, Log2BuffaSize);
    fftbuffa = calloc(fftBuffaFrames, sizeof(Float32));
    s_w_rate = sf / fftBuffaFrames;
    
    //基準となるsin波を生成しておく
    referenceSineWave = calloc(fftBuffaFrames, sizeof(Float32));
    float phase;
    for (long i = 0; i <fftBuffaFrames; i++) {
        phase = 2.*M_PI * 441.0 * i/sf;
        referenceSineWave[i] = sinf(phase);
    }
    
    fftBuffaChankCount = fftBuffaFrames / inNumberFrames;
    fftBuffaChankLastNum = fftBuffaChankCount - 1;
    fftBuffaChankCounter = fftBuffaChankLastNum;
    
    ChankSize = inNumberFrames * sizeof(Float32);
    fftbuffaCopyAdr = inNumberFrames * fftBuffaChankLastNum;
    
    
    //窓関数に使う配列
    window = calloc(fftBuffaFrames, sizeof(Float32));
    windowedInput = calloc(fftBuffaFrames, sizeof(Float32));
    
    //window関数生成
    vDSP_hamm_window(window, fftBuffaFrames, 0);
    
    
    //fftの準備
    fftSetUp = vDSP_create_fftsetup(fftLog2Buffasize + 1, FFT_RADIX2);
    outputVector = calloc(fftBuffaFrames, sizeof(Float32));
    
    splitComplex.realp = calloc(fftBuffaFrames,sizeof(Float32));
    splitComplex.imagp = calloc(fftBuffaFrames, sizeof(Float32));
}

-(void)FFTdealloc{
    
    vDSP_destroy_fftsetup(fftSetUp);
    free(fftbuffa);
    free(splitComplex.realp);
    free(splitComplex.imagp);
    free(outputVector);
    free(window);
    free(windowedInput);
    
}

@end
