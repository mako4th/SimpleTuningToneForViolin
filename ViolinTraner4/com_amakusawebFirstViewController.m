//
//  com_amakusawebFirstViewController.m
//  ViolinTraner4
//
//  Created by 岡部 誠 on 2013/08/20.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import "com_amakusawebFirstViewController.h"
#import "com_amakusawebPlaySineWaves.h"

@interface com_amakusawebFirstViewController ()

@end

@implementation com_amakusawebFirstViewController

float frecG,frecD,frecA,frecE;
int FRACTONEA = 442;
int isplay = 0;
const com_amakusawebPlaySineWaves *vs;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //周波数選択ステッパー初期化
    self.AfrecStepper.minimumValue = 430;
    self.AfrecStepper.maximumValue = 450;
    self.AfrecStepper.value = FRACTONEA;
    self.AfrecValue.text = [NSString stringWithFormat:@"%i",FRACTONEA];
    
    //周波数セット
    frecA = self.AfrecStepper.value;
    frecD = (frecA * 2)/3;
    frecG = (frecA * 4)/9;
    frecE = (frecA * 3)/2;
    
    
    vs = [[com_amakusawebPlaySineWaves alloc] init];
    vs.samplerate = 441000;
    vs.bitRate = 8;
    vs.frequency = 0;
    vs.wavetype = 1; //1:sin 2:三角 3:のこ
    vs.teperAMP = 0;
    vs.dupflg = 0;
    [vs playSineWave];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AfrecStepper:(UIStepper *)sender {
    vs.dupflg = 0;
    frecA = self.AfrecStepper.value;
    frecD = (frecA * 2)/3;
    frecG = (frecA * 4)/9;
    frecE = (frecA * 3)/2;
    NSLog(@"%f",frecA);
    self.AfrecValue.text = [NSString stringWithFormat:@"%.0f",frecA];
    if (isplay == 1) {
        switch (vs.nowPlaying) {
            case 1:
                [self ToneGwave];
                break;
            case 2:
                [self ToneDwave];
                break;
            case 3:
                [self ToneAwave];
                break;
            case 4:
                [self ToneEwave];
                break;
            case 5:
                [self ToneGDwave];
                break;
            case 6:
                [self ToneDAwave];
                break;
            case 7:
                [self ToneAEwave];
                break;
                
            default:
                break;
        }

    }
    }



- (void)ToneGwave{
    NSLog(@"G pressed");
    self.LabelFrec.text = [NSString stringWithFormat:@"%f",frecG];
    self.PitchLabel.text = @"G";
    vs.frequency = frecG;
    vs.frequency2 = frecG;
    vs.nowPlaying = 1;
    isplay = 1;
}


-(void)ToneDwave{
    NSLog(@"D pressed");
    self.LabelFrec.text = [NSString stringWithFormat:@"%f",frecD];
    self.PitchLabel.text = @"D";
    vs.frequency = frecD;
    vs.frequency2 = frecD;
    vs.nowPlaying = 2;
    isplay = 1;
}

-(void)ToneAwave{
    NSLog(@"A pressed");
    self.LabelFrec.text = [NSString stringWithFormat:@"%f",frecA];
    self.PitchLabel.text = @"A";
    vs.frequency = frecA;
    vs.frequency2 = frecA;
    vs.nowPlaying = 3;
    isplay = 1;
}

-(void)ToneEwave{
    NSLog(@"E pressed");
    self.LabelFrec.text = [NSString stringWithFormat:@"%f",frecE];
    self.PitchLabel.text = @"E";
    vs.frequency = frecE;
    vs.frequency2 = frecE;
    vs.nowPlaying = 4;
    isplay = 1;
}

-(void)ToneGDwave{
    NSLog(@"GD pressed");
    self.LabelFrec.text = @"GD";
    self.PitchLabel.text = @"GD";
    vs.frequency = frecG;
    vs.frequency2 = frecD;
    vs.nowPlaying = 5;
    isplay = 1;
}

-(void)ToneDAwave{
    NSLog(@"DA pressed");
    self.LabelFrec.text = @"DA";
    self.PitchLabel.text = @"DA";
    vs.frequency = frecD;
    vs.frequency2 = frecA;
    vs.nowPlaying = 6;
    isplay = 1;
}

-(void)ToneAEwave{
    NSLog(@"AE pressed");
    self.LabelFrec.text = @"AE";
    self.PitchLabel.text = @"AE";
    vs.frequency = frecA;
    vs.frequency2 = frecE;
    vs.nowPlaying = 7;
    isplay = 1;
}
-(void)StopWave{
    if (isplay == 1) {
        
        //        [vs stopSineWave];
        vs.frequency = 0;
        vs.frequency2 = 0;
        vs.dupflg = 0;
    }
    isplay = 0;
    UIColor *defaultcolor;
    defaultcolor = self.AfrecHzLabel.textColor;
    
    self.ToneA.backgroundColor = defaultcolor;
    self.ToneD.backgroundColor = defaultcolor;
    self.ToneG.backgroundColor = defaultcolor;
    self.ToneE.backgroundColor = defaultcolor;
    self.ToneGD.backgroundColor = defaultcolor;
    self.ToneDA.backgroundColor = defaultcolor;
    self.ToneAE.backgroundColor = defaultcolor;
    self.Stop.backgroundColor = defaultcolor;
    self.PitchLabel.textColor = defaultcolor;
    self.LabelFrec.textColor = defaultcolor;
}
- (IBAction)ToneA:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 3 && isplay == 1) {
        [self StopWave];
    }
    else
        [self ToneAwave];
}
- (IBAction)ToneE:(id)sender {
        [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 4 && isplay == 1) {
        [self StopWave];
    }
    else
    [self ToneEwave];
}
- (IBAction)ToneD:(id)sender {
        [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 2 && isplay == 1) {
        [self StopWave];
    }
    else
    [self ToneDwave];
}
- (IBAction)ToneG:(id)sender {
        [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 1 && isplay == 1) {
        [self StopWave];
    }
    else
    [self ToneGwave];
}
- (IBAction)ToneGD:(id)sender {
        [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 5 && isplay == 1) {
        [self StopWave];
    }
    else
    [self ToneGDwave];
}
- (IBAction)ToneDA:(id)sender {
        [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 6 && isplay == 1) {
        [self StopWave];
    }
    else
    [self ToneDAwave];
}
- (IBAction)ToneAE:(id)sender {
        [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 7 && isplay == 1) {
        [self StopWave];
    }
    else
    [self ToneAEwave];
}
- (IBAction)StopSound:(id)sender {
    [self ToneButtonChangeColler:sender];
    NSLog(@"stop pressed");
    [self StopWave];
    
}
- (IBAction)selectWavetypeSegmentedC:(id)sender {
    NSLog(@"%d",[sender selectedSegmentIndex]);
    vs.wavetype = [sender selectedSegmentIndex] + 1;
}

- (void)ToneButtonChangeColler:(UIButton *)playing
{
    UIColor *defaultcolor;
    defaultcolor = self.AfrecHzLabel.textColor;
    
    self.ToneA.backgroundColor = defaultcolor;
    self.ToneD.backgroundColor = defaultcolor;
    self.ToneG.backgroundColor = defaultcolor;
    self.ToneE.backgroundColor = defaultcolor;
    self.ToneGD.backgroundColor = defaultcolor;
    self.ToneDA.backgroundColor = defaultcolor;
    self.ToneAE.backgroundColor = defaultcolor;
    self.Stop.backgroundColor = defaultcolor;
    self.PitchLabel.textColor = defaultcolor;
    self.LabelFrec.textColor = defaultcolor;

    playing.backgroundColor = [UIColor colorWithRed:1.0 green:0.7 blue:1.0 alpha:1.0];

}



//AdBannerアニメーション
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect bannerFrame = self.bannerView.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    self.bannerView.frame = bannerFrame;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    CGRect bannerFrame = banner.frame;
    bannerFrame.origin.y = self.view.frame.size.height - banner.frame.size.height;
    [UIView animateWithDuration:1.0 animations:^{banner.frame = bannerFrame;}];
    NSLog(@"広告在庫あり");
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    CGRect bannerFrame = banner.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:1.0 animations:^{banner.frame = bannerFrame;}];
    NSLog(@"広告在庫なし");
    
}



@end
