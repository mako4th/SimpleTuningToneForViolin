//
//  com_amakusawebPlaySineWaves.m
//  ViolinTraner4
//
//  Created by 岡部 誠 on 2013/08/21.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import "com_amakusawebPlaySineWaves.h"

@implementation com_amakusawebPlaySineWaves

@synthesize phase,samplerate,bitRate,frequency,wavetype,nowPlaying,isTeper,TeperCount,teperAMP,lastFrec;

-(void)playSineWave{
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    
    AudioComponent ac = AudioComponentFindNext(NULL, &acd);
    
    AudioComponentInstanceNew(ac, &au);
    
    AudioUnitInitialize(au);
    
    // コールバックの設定
    AURenderCallbackStruct CallbackStruct;
    CallbackStruct.inputProc = renderer;     // ここでコールバック時に実行するメソッドを指定
    CallbackStruct.inputProcRefCon = (__bridge void*)self;
    
    
    AudioUnitSetProperty(au, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &CallbackStruct, sizeof(AURenderCallbackStruct));
    
    // AudioStreamBasicDescription(ASBD)の設定
    AudioStreamBasicDescription asbd;
    asbd.mSampleRate = samplerate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
    asbd.mChannelsPerFrame = 2;
    asbd.mBytesPerPacket = sizeof(AudioUnitSampleType);
    asbd.mBytesPerFrame = sizeof(AudioUnitSampleType);
    asbd.mFramesPerPacket = 1;
    asbd.mBitsPerChannel = bitRate * sizeof(AudioUnitSampleType);
    asbd.mReserved = 0;
    
    // AudioUnitにASBDを設定
    AudioUnitSetProperty(au,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0,
                         &asbd,
                         sizeof(asbd));
    
    
    // 再生開始
    AudioOutputUnitStart(au);
}


static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData
                         ) {
       float wave,wave2,xdash1,xdash2,cons1,cons1_1,cons1_2,cons2,cons2_1,cons2_2,sinprecalc;
    

    // 値を書き込むポインタ
    AudioUnitSampleType *outL = ioData->mBuffers[0].mData;
    AudioUnitSampleType *outR = ioData->mBuffers[1].mData;
       
    //サンプル値計算に使う変数のキャスト
    com_amakusawebPlaySineWaves* vsn = (__bridge com_amakusawebPlaySineWaves*)inRef;
    
    cons1 = vsn.samplerate/vsn.frequency; //一周期当りのビット数
    cons1_1 = cons1/2;
    cons1_2 = 4*vsn.frequency/vsn.samplerate;
    
    cons2 = vsn.samplerate/vsn.frequency2;
    cons2_1 = cons2/2;
    cons2_2 = 4*vsn.frequency2/vsn.samplerate;
    
    
    for (int i = 0; i < inNumberFrames; i++) {
        
        //量子化サンプルの計算
        //スイッチ
        switch (vsn.wavetype) {
            case 1: //sin波
                sinprecalc =2*M_PI*vsn.frequency*vsn.phase/vsn.samplerate;
                wave = sin(sinprecalc);
                wave2 = sin(2*M_PI*vsn.frequency2*vsn.phase/vsn.samplerate);
                wave = (wave+wave2)/2;
                break;
            case 2: //三角波
                xdash1 = fmodf(vsn.phase, (vsn.samplerate/vsn.frequency));
                xdash2 = fmodf(vsn.phase, (vsn.samplerate/vsn.frequency2));
                wave = (xdash1 < cons1_1 ? cons1_2*xdash1-1 : (-cons1_2)*xdash1+3);
                wave2 = (xdash2 < cons2_1 ? cons2_2*xdash2-1 : (-cons2_2)*xdash2+3);
                wave = (wave+wave2)/2;
                break;
            case 3: //鋸波
                wave = (2*vsn.frequency/vsn.samplerate)*fmodf(vsn.phase,(vsn.samplerate/vsn.frequency))-1;
                wave2 = (2*vsn.frequency2/vsn.samplerate)*fmodf(vsn.phase,(vsn.samplerate/vsn.frequency2))-1;
                wave = (wave+wave2)/2;
                break;
            default:
                break;
        }
        

        AudioUnitSampleType sample = wave * (1 << kAudioUnitSampleFractionBits);
        
       //バッファへ書き込み
        *outL++ = sample;
        *outR++ = sample;
       
    
        //次のサンプリング周期を計算
       vsn.phase++;

    }
       

    return noErr;
    
}

- (void)stopSineWave{
    // 再生停止
    AudioOutputUnitStop(au);
    
    // AudioUnitの解放
    AudioUnitUninitialize(au);
    AudioComponentInstanceDispose(au);
    
}

- (void)testSineWave{
    NSLog(@"testsinwave");
}

@end