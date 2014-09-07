//
//  com.amakusaweb.FFTreturnArrays.h
//  OkabeFFTRefactor
//
//  Created by 岡部 誠 on 2014/09/01.
//  Copyright (c) 2014年 MAKOTO OKABE. All rights reserved.
//



#import <Foundation/Foundation.h>

#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>


@interface com_amakusaweb_fft : NSObject

-(id)initWithBuffaSizeLog2:(int)BuffasizeLog2   returnArray:(float*)returnArray;


-(void)FFTdealloc;

@property float SampleRate;

@end
