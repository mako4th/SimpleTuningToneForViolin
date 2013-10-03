//
//  com_amakusawebPlaySineWaves.h
//  ViolinTraner4
//
//  Created by 岡部 誠 on 2013/08/21.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


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
@property (nonatomic) int isTeper;
@property (nonatomic) float TeperCount;
@property (nonatomic) float teperAMP;
@property (nonatomic) Float64 lastFrec;
@property (nonatomic) double VolumePhaseCounter;
@property (nonatomic) Float64 oldfrequency;
@property (nonatomic) Float64 newfrequency;
@property (nonatomic) int dupflg;


static OSStatus renderer(void * inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData);

- (void) playSineWave;
- (void) stopSineWave;
- (void) testSineWave;
@end
