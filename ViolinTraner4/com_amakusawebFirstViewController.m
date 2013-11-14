//
//  com_amakusawebFirstViewController.m
//  ViolinTraner4
//
//  Created by 岡部 誠 on 2013/08/20.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import "com_amakusawebFirstViewController.h"
#import "com_amakusawebPlaySineWaves.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface com_amakusawebFirstViewController ()

@end

@implementation com_amakusawebFirstViewController

float frecG,frecD,frecA,frecE;
int FRACTONEA = 442;
int Localwavetype;
const com_amakusawebPlaySineWaves *vs;

int bottomY = 0;
int areawidth = 0;

//画面回転有効
- (BOOL)shouldAutorotate{
    return YES;
}

//全方向対応
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(void)viewDidAppear:(BOOL)animated{
    //画面オブジェクトのサイズ設定
    [self resizeViewObjects];
    [super viewDidAppear:animated];
}

//画面回転開始時
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewObjects];
}

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
    
    self.LabelFrec.text = [NSString stringWithFormat:@"A = %f Hz",frecA];
    
    //playSinWaveの初期設定：無音
    vs = [[com_amakusawebPlaySineWaves alloc] init];
    vs.samplerate = 44100;
    vs.bitRate = 8;
    vs.frequency = FRACTONEA;
    vs.frequency2 = FRACTONEA;
    Localwavetype = vs.wavetype = 1; //1:sin 2:三角 3:のこ
    vs.taperAMP = 0;
    
    [vs playSineWave];
    
}

-(void)resizeViewObjects{
    int statusbarheight,firstrowTopY,secondrowTopY,thirdrowTopY,forthrowTopY,LabelNoteTopY,sixthrowTopY,AtoEsFontSize,btnwidth,btnheight,dupToneWidth,dupToneheight,duptoneFontSize,Leftx,sixthrowCenterY,areaheight;
    
    int margin = 2;
    int areaoriginY = 0;
    CGRect appframesize = [[UIScreen mainScreen] applicationFrame];
    CGRect bounsframesize = [[UIScreen mainScreen] bounds];
    
    [UIView beginAnimations:@"aaaaaa" context:NULL];
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        areawidth = appframesize.size.width;
        areaheight = appframesize.size.height;
        statusbarheight = (int)UIApplication.sharedApplication.statusBarFrame.size.height;
        bottomY = areaheight;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            areaoriginY = statusbarheight;
            bottomY += statusbarheight;
            NSLog(@"ios7以上");
        }else{
            NSLog(@"ios7以下");
        }
        
        btnwidth = roundf((areawidth - margin*3)/2);
        btnheight = roundf((areaheight - self.banner.frame.size.height - 90 - margin*5)/2.5);
        dupToneheight = btnheight / 2;
        dupToneWidth = roundf((areawidth - margin*4)/3);
        
        firstrowTopY = areaoriginY + _LabelFrec.frame.size.height;
        secondrowTopY = firstrowTopY + btnheight + margin;
        thirdrowTopY = secondrowTopY + btnheight + margin;
        forthrowTopY = thirdrowTopY + dupToneheight;
        
        _ToneGD.frame = CGRectMake(margin, thirdrowTopY, dupToneWidth, dupToneheight);
        _ToneDA.frame = CGRectMake(margin*2 + dupToneWidth,thirdrowTopY, dupToneWidth, dupToneheight);
        _ToneAE.frame = CGRectMake(margin*3 + dupToneWidth*2,thirdrowTopY, dupToneWidth, dupToneheight);
     
    }else{
        areawidth = appframesize.size.height;
        areaheight = appframesize.size.width;
        statusbarheight = (int)UIApplication.sharedApplication.statusBarFrame.size.width;
        bottomY = areaheight;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            areaoriginY = statusbarheight;
            bottomY += areaoriginY;
            NSLog(@"ios7以上");
        }else{
            NSLog(@"ios7以下");
        }
        
        btnwidth = roundf((areawidth - margin*4)/3);
        btnheight = roundf((areaheight - self.banner.frame.size.height - 90 - margin*6)/2);
        dupToneheight = ((btnheight * 2 + margin)-margin*2)/3;
        dupToneWidth = btnwidth;

        firstrowTopY = areaoriginY + _LabelFrec.frame.size.height;
        secondrowTopY = firstrowTopY + btnheight + margin;
        forthrowTopY = secondrowTopY + btnheight + margin;
        
        _ToneGD.frame = CGRectMake(btnwidth*2 + margin*3, firstrowTopY, dupToneWidth, dupToneheight);
        _ToneDA.frame = CGRectMake(btnwidth*2 + margin*3,firstrowTopY + dupToneheight + margin, dupToneWidth, dupToneheight);
        _ToneAE.frame = CGRectMake(btnwidth*2 + margin*3,firstrowTopY + dupToneheight*2 + margin*2, dupToneWidth, dupToneheight);
    }
   
    _LabelFrec.frame = CGRectMake(margin, areaoriginY, 128, 20);

    AtoEsFontSize = roundf(btnheight*0.8);
    _ToneA.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];
    _ToneD.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];
    _ToneG.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];
    _ToneE.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];
    
    duptoneFontSize = roundf(dupToneheight*0.6);
    _ToneGD.titleLabel.font = [UIFont systemFontOfSize:duptoneFontSize];
    _ToneDA.titleLabel.font = [UIFont systemFontOfSize:duptoneFontSize];
    _ToneAE.titleLabel.font = [UIFont systemFontOfSize:duptoneFontSize];

    
    _ToneA.frame = CGRectMake(margin, firstrowTopY, btnwidth, btnheight);
    _ToneD.frame = CGRectMake(btnwidth+margin*2,firstrowTopY, btnwidth, btnheight);
    _ToneG.frame = CGRectMake(margin,secondrowTopY,btnwidth,btnheight);
    _ToneE.frame = CGRectMake(btnwidth+margin*2,secondrowTopY, btnwidth, btnheight);
    
    _LabelNote.frame = CGRectMake(margin, forthrowTopY, appframesize.size.width, 15);
    
    LabelNoteTopY = forthrowTopY + _LabelNote.frame.size.height;
    
    _selectWavetype.frame = CGRectMake(margin, LabelNoteTopY, areawidth-margin*2, 26);
    
    sixthrowTopY = LabelNoteTopY + _selectWavetype.frame.size.height;
    sixthrowCenterY = sixthrowTopY + 36/2;
    
    int sixthrowBottomY = sixthrowTopY + 36;
    Leftx = margin;
    _AfrecStepper.frame = CGRectMake(Leftx, sixthrowCenterY - 27/2, 94, 27);
    Leftx += _AfrecStepper.frame.size.width + margin;
    _stepperFrecLabel.frame = CGRectMake(Leftx,sixthrowBottomY - 21 ,27, 21);
    Leftx += _stepperFrecLabel.frame.size.width + margin;
    _AfrecValue.frame = CGRectMake(Leftx, sixthrowCenterY - 36/2, 75, 36);
    Leftx += _AfrecValue.frame.size.width + margin;
    _stepperFreclabelHz.frame = CGRectMake(Leftx, sixthrowBottomY - 21, 34, 21);
    Leftx += _stepperFreclabelHz.frame.size.width + margin;
    _helpButton.frame = CGRectMake(Leftx, sixthrowCenterY - 19/2, 18, 19);
    _ToneA.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];

    if (_bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerchangeOrientation" context:NULL];
        _banner.frame = CGRectMake(0, bottomY - _banner.frame.size.height, areawidth, 50);
        _banner.alpha = 1.0f;
        [UIView commitAnimations];
    }else{
        _banner.frame = CGRectMake(0, bottomY, areawidth, 50);
        _banner.alpha = 0.0f;
    }
    
    NSLog(@"orientation = %d",self.interfaceOrientation);
//    NSLog(@"arearWidth  = %d",areawidth);
//    NSLog(@"arearHeight = %d",areaheight);
//    NSLog(@"bottomY     = %d",bottomY);
//    NSLog(@"banner origin x=%f y=%f",_banner.frame.origin.x,_banner.frame.origin.y);
//    NSLog(@"banner size   w=%f h=%f",_banner.frame.size.width,_banner.frame.size.height);
//    NSLog(@"statusbar size    = %d",statusbarheight);
//    NSLog(@"bouns origin x    = %f",bounsframesize.origin.x);
//    NSLog(@"bouns origin y    = %f",bounsframesize.origin.y);
//    NSLog(@"bouns width       = %f",bounsframesize.size.width);
//    NSLog(@"bouns height      = %f",bounsframesize.size.height);
//    NSLog(@"appframe origin x = %f",appframesize.origin.x);
//    NSLog(@"appframe origin y = %f",appframesize.origin.y);
//    NSLog(@"appframe width    = %f",appframesize.size.width);
//    NSLog(@"appframe height   = %f",appframesize.size.height);
    [UIView commitAnimations];
    
}
    
    
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AfrecStepper:(UIStepper *)sender {
    frecA = self.AfrecStepper.value;
    frecD = (frecA * 2)/3;
    frecG = (frecA * 4)/9;
    frecE = (frecA * 3)/2;
    NSLog(@"%f",frecA);
    self.AfrecValue.text = [NSString stringWithFormat:@"%.0f",frecA];
    [self ToneResume];
}

- (void)ToneGwave{
    [self DownTaper];
    NSLog(@"G pressed");
    self.LabelFrec.text = [NSString stringWithFormat:@"G = %f Hz",frecG];
    vs.flgUpTaper = 1;
    vs.UPTaperCount = 0;
    vs.frequency = frecG;
    vs.frequency2 = frecG;
    vs.nowPlaying = 1;
    vs.isplay = 1;
}

-(void)ToneDwave{
    [self DownTaper];
    NSLog(@"D pressed");
    self.LabelFrec.text = [NSString stringWithFormat:@"D = %f Hz",frecD];
    vs.flgUpTaper = 1;
    vs.UPTaperCount = 0;
    vs.frequency = frecD;
    vs.frequency2 = frecD;
    vs.nowPlaying = 2;
    vs.isplay = 1;
}

-(void)ToneAwave{
    NSLog(@"A pressed");
    [self DownTaper];
    self.LabelFrec.text = [NSString stringWithFormat:@"A = %f Hz",frecA];
    vs.wavetype = Localwavetype;
    vs.flgUpTaper = 1;
    vs.UPTaperCount = 0;
    vs.frequency = frecA;
    vs.frequency2 = frecA;
    vs.nowPlaying = 3;
    vs.isplay = 1;
}

-(void)ToneEwave{
    NSLog(@"E pressed");
    [self DownTaper];
    self.LabelFrec.text = [NSString stringWithFormat:@"E = %f Hz",frecE];
    vs.wavetype = Localwavetype;
    vs.flgUpTaper = 1;
    vs.UPTaperCount = 0;
    vs.frequency = frecE;
    vs.frequency2 = frecE;
    vs.nowPlaying = 4;
    vs.isplay = 1;
}

-(void)ToneGDwave{
    NSLog(@"GD pressed");
    [self DownTaper];
    self.LabelFrec.text = @"GD";
    vs.wavetype = Localwavetype;
    vs.flgUpTaper = 1;
    vs.UPTaperCount = 0;
    vs.frequency = frecG;
    vs.frequency2 = frecD;
    vs.nowPlaying = 5;
    vs.isplay = 1;
}

-(void)ToneDAwave{
    NSLog(@"DA pressed");
    [self DownTaper];
    self.LabelFrec.text = @"DA";
    vs.wavetype = Localwavetype;
    vs.flgUpTaper = 1;
    vs.UPTaperCount = 0;
    vs.frequency = frecD;
    vs.frequency2 = frecA;
    vs.nowPlaying = 6;
    vs.isplay = 1;
}

-(void)ToneAEwave{
    NSLog(@"AE pressed");
    [self DownTaper];
    self.LabelFrec.text = @"AE";
    vs.wavetype = Localwavetype;
    vs.flgUpTaper = 1;
    vs.UPTaperCount = 0;
    vs.frequency = frecA;
    vs.frequency2 = frecE;
    vs.nowPlaying = 7;
    vs.isplay = 1;
}

-(void)DownTaper{
    if (vs.isplay == 1) {
        vs.DownTaperCount = TaperCountDefoultNum;
        vs.flgDownTaper = 1;
        while (vs.flgDownTaper == 1 ) {
            ;
        }
        vs.phase = 0;
        vs.wavetype = Localwavetype;
    }
}

-(void)StopWave{
    [self DownTaper];
    vs.isplay = 0;
    UIColor *defaultcolor;
    defaultcolor = self.LabelFrec.textColor;
    
    self.ToneA.backgroundColor = defaultcolor;
    self.ToneD.backgroundColor = defaultcolor;
    self.ToneG.backgroundColor = defaultcolor;
    self.ToneE.backgroundColor = defaultcolor;
    self.ToneGD.backgroundColor = defaultcolor;
    self.ToneDA.backgroundColor = defaultcolor;
    self.ToneAE.backgroundColor = defaultcolor;
    self.LabelFrec.textColor = defaultcolor;
}

- (IBAction)ToneA:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 3 && vs.isplay == 1) {
        [self StopWave];
    }
    else
        [self ToneAwave];
}

- (IBAction)ToneE:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 4 && vs.isplay == 1) {
        [self StopWave];
    }
    else
        [self ToneEwave];
}

- (IBAction)ToneD:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 2 && vs.isplay == 1) {
        [self StopWave];
    }
    else
        [self ToneDwave];
}

- (IBAction)ToneG:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 1 && vs.isplay == 1) {
        [self StopWave];
    }
    else
        [self ToneGwave];
}

- (IBAction)ToneGD:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 5 && vs.isplay == 1) {
        [self StopWave];
    }
    else
        [self ToneGDwave];
}

- (IBAction)ToneDA:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 6 && vs.isplay == 1) {
        [self StopWave];
    }
    else
        [self ToneDAwave];
}

- (IBAction)ToneAE:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 7 && vs.isplay == 1) {
        [self StopWave];
    }
    else
        [self ToneAEwave];
}

- (IBAction)selectWavetypeSegmentedC:(id)sender {
    NSLog(@"%d",[sender selectedSegmentIndex]);
    Localwavetype = [sender selectedSegmentIndex] + 1;
    if (vs.isplay == 0) {
        vs.wavetype = Localwavetype;
    }else
        [self ToneResume];
}

- (void)ToneButtonChangeColler:(UIButton *)playing
{
    UIColor *defaultcolor;
    defaultcolor = self.LabelFrec.textColor;
    
    self.ToneA.backgroundColor = defaultcolor;
    self.ToneD.backgroundColor = defaultcolor;
    self.ToneG.backgroundColor = defaultcolor;
    self.ToneE.backgroundColor = defaultcolor;
    self.ToneGD.backgroundColor = defaultcolor;
    self.ToneDA.backgroundColor = defaultcolor;
    self.ToneAE.backgroundColor = defaultcolor;
    self.LabelFrec.textColor = defaultcolor;
    playing.backgroundColor = [UIColor colorWithRed:1.0 green:0.7 blue:1.0 alpha:1.0];
}

-(void)ToneResume{
    if (vs.isplay == 1) {
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

//AdBannerアニメーション
-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectMake(0, bottomY - banner.frame.size.height, areawidth, 50);
        banner.alpha = 1.0f;
        [UIView commitAnimations];
        _bannerIsVisible = YES;
    }
    NSLog(@"広告在庫あり");
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectMake(0, bottomY, areawidth, 50);
        banner.alpha = 0.0f;
        [UIView commitAnimations];
        _bannerIsVisible = NO;
    }
    NSLog(@"広告在庫なし");
}

@end
