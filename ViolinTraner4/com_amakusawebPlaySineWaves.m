//
//  com_amakusawebPlaySineWaves.m
//  ViolinTraner4
//
//  Created by 岡部 誠 on 2013/08/21.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import "com_amakusawebPlaySineWaves.h"

#import <AVFoundation/AVFoundation.h>

@implementation com_amakusawebPlaySineWaves

@synthesize phase,samplerate,bitRate,frequency,wavetype,nowPlaying,taperAMP,lastFrec,flgOFF,flgTaperOn,TaperOn;

com_amakusawebPlaySineWaves *vsn;

-(void)playSineWave{
    //サイレントモードでも音をならす
//    AudioSessionInitialize(NULL, NULL, NULL, NULL);
//    UInt32 category = kAudioSessionCategory_MediaPlayback;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
//                            sizeof(UInt32),
//                            &category);
//    AudioSessionSetActive(YES);
//    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioSession setActive:YES error:nil];
    
    //出力種別を調べる
    AVAudioSessionRouteDescription *routeDescription = [[AVAudioSession sharedInstance] currentRoute];
    for(AVAudioSessionPortDescription *output in [routeDescription outputs]){
        NSLog(@"output route = %@",[output portName]);
    }
    for(AVAudioSessionPortDescription *input in [routeDescription inputs]){
        NSLog(@"input route = %@",[input portName]);
    }
    
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    
    AudioComponent ac = AudioComponentFindNext(NULL, &acd);
    
    AudioComponentInstanceNew(ac, &au);
    
    
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
    //マイク入力をオンにする
    UInt32 flag = 1;
    AudioUnitSetProperty(au,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         1,
                         &flag,
                         sizeof(UInt32));
    // 再生開始
    AudioUnitInitialize(au);    AudioOutputUnitStart(au);
    
}


static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData
                         ) {
    float wave,wave2,xdash1,xdash2,cons1,cons1_1,cons1_2,cons2,cons2_1,cons2_2;
    
    
    // 値を書き込むポインタ
    AudioUnitSampleType *outL = ioData->mBuffers[0].mData;
    AudioUnitSampleType *outR = ioData->mBuffers[1].mData;
    
    //サンプル値計算に使う変数のキャスト
    vsn = (__bridge com_amakusawebPlaySineWaves*)inRef;

    for (int i = 0; i < inNumberFrames; i++) {
        
        //量子化サンプルの計算 波形毎
        switch (vsn.wavetype) {
            case 1: //sin波
                wave = sin(2.*M_PI*vsn.frequency*vsn.phase/vsn.samplerate);
                wave2 = sin(2.*M_PI*vsn.frequency2*vsn.phase/vsn.samplerate);
                wave = (wave+wave2)/2.;
                wave = wave * vsn.getAMP;
                break;
            case 2: //三角波
                cons1 = vsn.samplerate/vsn.frequency;
                cons1_1 = cons1/2.;
                cons1_2 = 4. * vsn.getAMP * vsn.frequency/vsn.samplerate;
                
                cons2 = vsn.samplerate/vsn.frequency2;
                cons2_1 = cons2/2.;
                cons2_2 = 4. * vsn.getAMP * vsn.frequency2/vsn.samplerate;
                
                xdash1 = fmodf(vsn.phase, cons1);
                xdash2 = fmodf(vsn.phase, cons2);
                
                wave = (xdash1 < cons1_1 ? cons1_2*xdash1-vsn.getAMP : (-cons1_2)*xdash1+3. * vsn.getAMP);
                wave2 = (xdash2 < cons2_1 ? cons2_2*xdash2-vsn.getAMP : (-cons2_2)*xdash2+3. * vsn.getAMP);
                wave = (wave+wave2)/2.;
                wave = wave * vsn.getAMP;
                break;
            case 3: //鋸波
                cons1 = vsn.samplerate/vsn.frequency;
                cons1_2 = 2. * vsn.getAMP * vsn.frequency/vsn.samplerate;
                cons2 = vsn.samplerate/vsn.frequency2;
                cons2_2 = 2. * vsn.getAMP * vsn.frequency2/vsn.samplerate;
                
                wave = cons1_2 * fmodf(vsn.phase,cons1)-vsn.getAMP;
                wave2 = cons2_2 * fmodf(vsn.phase,cons2)-vsn.getAMP;
                wave = (wave+wave2)/2.;
                wave = wave * vsn.getAMP;
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

- (float) getAMP{

    //鳴り始めのテーパ
    if (vsn.flgUpTaper == 1) {
        vsn.taperAMP = vsn.UPTaperCount/(float)vsn.UPTaperMaxCount;
        vsn.UPTaperCount++;
        if (vsn.UPTaperCount == vsn.UPTaperMaxCount) {
            vsn.flgUpTaper = 0;
            vsn.UPTaperCount = 0;
            vsn.taperAMP = 1;
        }
    }
    
    //鳴り終わりのテーパ
    if (vsn.flgDownTaper == 1) {
        vsn.taperAMP -= 1.0/DownTaperDefoultNum;
        if (vsn.taperAMP < 0) {
            vsn.phase = 0;
            vsn.isplay = 0;
            vsn.flgDownTaper = 0;
            vsn.taperAMP = 0;
        }
    }
    //NSLog(@"taperAMP = %f",vsn.taperAMP);
    return vsn.taperAMP;
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
