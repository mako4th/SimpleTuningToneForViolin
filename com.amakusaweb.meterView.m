//
//  com.amakusaweb.meterView.m
//  TuningTone
//
//  Created by 岡部 誠 on 2014/09/03.
//  Copyright (c) 2014年 MAKOTO OKABE. All rights reserved.
//

#import "com.amakusaweb.meterView.h"

@implementation com_amakusaweb_meterView{
    float * value;
    //画面描画のタイマー
    NSTimeInterval displayInterval;
    NSTimer *displayTimer;
}

- (id)initWithFrame:(CGRect)frame result:(float*)result
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        value = result;
        self.backgroundColor = [UIColor colorWithRed:126.0/255.0 green:191/255.0 blue:218/255.0 alpha:0.8];
        
        //画面描画のタイマー
        
        displayInterval = 1./20.;
        displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayInterval target:self selector:@selector(drawview) userInfo:nil repeats:YES];
        
        int x = 20,y=20;
        
        for (int i = 1; i<=5 ; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(x, y, 200, 30);
            label.text = [NSString stringWithFormat:@"%f",value[i-1]];
            label.tag = i;
            [self addSubview:label];
            
            y += 30;
        }
        
        
        
        
        
    }
    
    
    
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[self removeFromSuperview];
}
-(void)drawview{
    for (int i = 1; i<=5 ; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:i];
        label.text = [NSString stringWithFormat:@"%f",value[i-1]];
       // printf("%f",value[i-1]);
    }
    
}

@end
