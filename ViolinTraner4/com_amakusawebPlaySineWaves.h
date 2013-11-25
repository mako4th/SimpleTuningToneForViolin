//
//  com_amakusawebPlaySineWaves.h
//  ViolinTraner4
//
//  Created by 岡部 誠 on 2013/08/21.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define TaperCountDefoultNum 8820.0
#define DownTaperDefoultNum 2205.0

@interface com_amakusawebPlaySineWaves : NSObject{
    AudioUnit au;
    double phase;
    Float64 sampleRate;
    UInt32 bitRate;
    Float64 frequency;
}

@property (nonatomic) double phase;
@property (nonatomic) Float64 samplerate;
@property (nonatomic) UInt32 bitRate;
@property (nonatomic) Float64 frequency;
@property (nonatomic) Float64 frequency2;
@property (nonatomic) int wavetype;
@property (nonatomic) int nowPlaying;
@property (nonatomic) BOOL flgTaperOn;
@property (nonatomic) int UPTaperCount;
@property (nonatomic) int DownTaperCount;
@property (nonatomic) double UPTaperMaxCount;
@property (nonatomic) float TaperOn;
@property (nonatomic) float taperAMP;
@property (nonatomic) Float64 lastFrec;
@property (nonatomic) double VolumePhaseCounter;
@property (nonatomic) Float64 oldfrequency;
@property (nonatomic) Float64 newfrequency;
@property (nonatomic) BOOL flgOFF;
@property (nonatomic) BOOL flgUpTaper;
@property (nonatomic) BOOL flgDownTaper;
@property (nonatomic) BOOL isplay;

static OSStatus renderer(void * inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData);

- (void) playSineWave;
- (void) stopSineWave;
- (void) testSineWave;
- (float) getAMP;
@end
