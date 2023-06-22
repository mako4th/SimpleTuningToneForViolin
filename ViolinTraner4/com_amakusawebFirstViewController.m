//
//  com_amakusawebFirstViewController.m
//  ViolinTraner4
//
//  Created by 岡部 誠 on 2013/08/20.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import "com_amakusawebFirstViewController.h"
#import "com_amakusawebPlaySineWaves.h"
//#import "com.amakusaweb.fft.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface com_amakusawebFirstViewController ()

@end

@implementation com_amakusawebFirstViewController{
//com_amakusaweb_fft *fft;
//    float fftresult[5];
//    float *fftresult;
}

float freqG,freqD,freqA,freqE;
int FRACTONEA = 442;
int Localwavetype;
const com_amakusawebPlaySineWaves *vs;

int bottomY = 0;
int areawidth = 0;
bool octSwitch = NO;

//画面回転有効
- (BOOL)shouldAutorotate{
    return YES;
}

//全方向対応
//- (NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskAll;
//}

-(void)viewDidAppear:(BOOL)animated{
    //画面オブジェクトのサイズ設定
    [self resizeViewObjects];
    [super viewDidAppear:animated];
}

-(void)loadView:(BOOL)animated{
    
    [self resizeViewObjects];
    [super viewDidAppear:animated];
}
//画面回転開始時
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self resizeViewObjects];
}

//バックグラウンド移行時の処理
-(void)bgStopWave:(NSNotification *)notification{
    //終了時の周波数（A)と波形の保存
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:self.AfrecStepper.value forKey:@"afrecsteppervalue"];
    [ud setInteger:self.selectWavetype.selectedSegmentIndex forKey:@"selectwavetype"];
    
    [self StopWave];
}

#pragma mark =====================
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    fftresult = calloc(5, sizeof(float));
//    
//    fft = [[com_amakusaweb_fft alloc] initWithBuffaSizeLog2:16 returnArray:fftresult];//2^14=16384  2^15=32768 2^16=65536 2^17=131072
    //アプリ終了時の処理
    if (&UIApplicationWillTerminateNotification) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(bgStopWave:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
    }
    
    //保存されたユーザ設定値呼び出しとデフォルト値の設定
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:@"442" forKey:@"afrecsteppervalue"];
    [defaults setObject:@"0" forKey:@"selectwavetype"];
    [ud registerDefaults:defaults];
    //周波数選択ステッパー初期化
    self.AfrecStepper.minimumValue = 430;
    self.AfrecStepper.maximumValue = 450;
    self.AfrecStepper.value = [ud integerForKey:@"afrecsteppervalue"];
    NSLog(@"stepper value = %f",self.AfrecStepper.value);
    self.AfrecValue.text = [NSString stringWithFormat:@"%i",(int)self.AfrecStepper.value];

    //周波数セット
    freqA = self.AfrecStepper.value;
    freqD = (freqA * 2)/3;
    freqG = (freqA * 4)/9;
    freqE = (freqA * 3)/2;
    
    self.LabelFrec.text = [NSString stringWithFormat:@"%.4f Hz",freqA];
    
    //playSinWaveの初期設定：無音
    vs = [[com_amakusawebPlaySineWaves alloc] init];
    vs.samplerate = 44100;
    vs.bitRate = 8;
    vs.frequency = FRACTONEA;
    vs.frequency2 = FRACTONEA;
    
    //波形タイプ設定読み込み　デフォルトは0
    self.selectWavetype.selectedSegmentIndex = [ud integerForKey:@"selectwavetype"];
    if (_selectWavetype.selectedSegmentIndex == 3) {
        octSwitch = YES;
        Localwavetype = 1;
        vs.wavetype = 1;
        _ToneGD.enabled = NO;
        _ToneDA.enabled = NO;
        _ToneAE.enabled = NO;
        [self octBtnChangeColor];
    }else{
    Localwavetype = vs.wavetype = (int)self.selectWavetype.selectedSegmentIndex + 1;
    }
    vs.taperAMP = 0;
    [vs playSineWave];
}

-(void)resizeViewObjects{
    int statusbarheight,firstrowTopY,secondrowTopY,thirdrowTopY,forthrowTopY,LabelNoteTopY,sixthrowTopY,AtoEsFontSize,btnwidth,btnheight,dupToneWidth,dupToneheight,duptoneFontSize,Leftx,sixthrowCenterY,areaheight;

    int margin = 5;
    int areaoriginY = 0;
    CGRect appframesize = [[UIScreen mainScreen] bounds];
 //   CGRect bounsframesize = [[UIScreen mainScreen] bounds];

    [UIView beginAnimations:@"aaaaaa" context:NULL];
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait
        || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
    {
        areawidth = appframesize.size.width;
        areaheight = appframesize.size.height - 60;
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
        btnheight = roundf((areaheight - 90 - margin*5)/2.5);
        dupToneheight = btnheight / 2;
        dupToneWidth = roundf((areawidth - margin*4)/3);

        firstrowTopY = areaoriginY + _LabelFrec.frame.size.height;
        secondrowTopY = firstrowTopY + btnheight + margin;
        thirdrowTopY = secondrowTopY + btnheight + margin;
        forthrowTopY = thirdrowTopY + dupToneheight;

        _ToneGD.frame = CGRectMake(margin, thirdrowTopY, dupToneWidth, dupToneheight);
        _ToneDA.frame = CGRectMake(margin*2 + dupToneWidth,thirdrowTopY, dupToneWidth, dupToneheight);
        _ToneAE.frame = CGRectMake(margin*3 + dupToneWidth*2,thirdrowTopY, dupToneWidth, dupToneheight);

        _LabelFrec.frame = CGRectMake(margin, areaoriginY, 128, 20);

        AtoEsFontSize = roundf(btnheight*0.8);
        _ToneA.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];
        _ToneD.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];
        _ToneG.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];
        _ToneE.titleLabel.font = [UIFont systemFontOfSize:AtoEsFontSize];

        duptoneFontSize = roundf(dupToneheight*0.4);
        _ToneGD.titleLabel.font = [UIFont systemFontOfSize:duptoneFontSize];
        _ToneDA.titleLabel.font = [UIFont systemFontOfSize:duptoneFontSize];
        _ToneAE.titleLabel.font = [UIFont systemFontOfSize:duptoneFontSize];

        _ToneA.frame = CGRectMake(margin, firstrowTopY, btnwidth, btnheight);
        _ToneD.frame = CGRectMake(btnwidth+margin*2,firstrowTopY, btnwidth, btnheight);
        _ToneG.frame = CGRectMake(margin,secondrowTopY,btnwidth,btnheight);
        _ToneE.frame = CGRectMake(btnwidth+margin*2,secondrowTopY, btnwidth, btnheight);

        _LabelNote.frame = CGRectMake(margin, forthrowTopY, appframesize.size.width, 15);

        LabelNoteTopY = forthrowTopY + _LabelNote.frame.size.height;

        _selectWavetype.frame = CGRectMake(margin, LabelNoteTopY, areawidth-margin*3, 26);
        sixthrowTopY = LabelNoteTopY + _selectWavetype.frame.size.height;
        sixthrowCenterY = sixthrowTopY + 36/2;

        int sixthrowBottomY = sixthrowTopY + 36;
        Leftx = margin;
        _AfrecStepper.frame = CGRectMake(Leftx, sixthrowCenterY - 27/2, 94, 27);
        Leftx += _AfrecStepper.frame.size.width + margin*8;
        _stepperFrecLabel.frame = CGRectMake(Leftx,sixthrowBottomY - 21 ,27, 21);
        Leftx += _stepperFrecLabel.frame.size.width + margin;
        _AfrecValue.frame = CGRectMake(Leftx, sixthrowCenterY - 36/2, 75, 36);
        Leftx += _AfrecValue.frame.size.width + margin;
        _stepperFreclabelHz.frame = CGRectMake(Leftx, sixthrowBottomY - 21, 34, 21);
        Leftx += _stepperFreclabelHz.frame.size.width + margin;
        _helpButton.frame = CGRectMake(Leftx, sixthrowCenterY - 5, 18, 19);

    }else{
        areawidth = appframesize.size.width;
        areaheight = appframesize.size.height;
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
        btnheight = roundf((areaheight - 70 - margin*6)/2);
        dupToneheight = ((btnheight * 2 + margin)-margin*2)/3;
        dupToneWidth = btnwidth;

        firstrowTopY = areaoriginY + _LabelFrec.frame.size.height;
        secondrowTopY = firstrowTopY + btnheight + margin;
        forthrowTopY = secondrowTopY + btnheight + margin;

        _ToneGD.frame = CGRectMake(btnwidth*2 + margin*3, firstrowTopY, dupToneWidth, dupToneheight);
        _ToneDA.frame = CGRectMake(btnwidth*2 + margin*3,firstrowTopY + dupToneheight + margin, dupToneWidth, dupToneheight);
        _ToneAE.frame = CGRectMake(btnwidth*2 + margin*3,firstrowTopY + dupToneheight*2 + margin*2, dupToneWidth, dupToneheight);

        _LabelFrec.frame = CGRectMake(margin + 100, areaoriginY, 128, 20);

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

        LabelNoteTopY = forthrowTopY;

        sixthrowTopY = LabelNoteTopY + _LabelNote.frame.size.height;
        sixthrowCenterY = sixthrowTopY + 36/2;

        int sixthrowBottomY = sixthrowTopY + 36;
        Leftx = margin + 10;
        _AfrecStepper.frame = CGRectMake(Leftx, sixthrowCenterY - 27/2, 94, 27);
        Leftx += _AfrecStepper.frame.size.width + margin * 3;
        _stepperFrecLabel.frame = CGRectMake(Leftx,sixthrowBottomY - 21 ,27, 21);
        Leftx += _stepperFrecLabel.frame.size.width + margin;
        _AfrecValue.frame = CGRectMake(Leftx, sixthrowCenterY - 36/2, 100, 36);
        Leftx += _AfrecValue.frame.size.width;
        _stepperFreclabelHz.frame = CGRectMake(Leftx, sixthrowBottomY - 21, 30, 21);
        Leftx += _stepperFreclabelHz.frame.size.width;
        _selectWavetype.frame = CGRectMake(Leftx-5, sixthrowCenterY - 13, areawidth-Leftx-20, 26);
        Leftx += _selectWavetype.frame.size.width;
        _helpButton.frame = CGRectMake(Leftx, sixthrowCenterY - 19/2, 18, 19);
    }

    NSLog(@"orientation = %ld",[[UIApplication sharedApplication] statusBarOrientation]);
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
    freqA = self.AfrecStepper.value;
    freqD = (freqA * 2)/3;
    freqG = (freqA * 4)/9;
    freqE = (freqA * 3)/2;
    NSLog(@"%f",freqA);
    self.AfrecValue.text = [NSString stringWithFormat:@"%.0f",freqA];
    [self ToneResume];
}

- (void)changeFreq1:(Float64)freq1 Freq2:(Float64)freq2 NowPlaying:(int)nowPlaying{
    [self DownTaper];
    NSLog(@"pressed %@", [[NSNumber numberWithFloat:freq1] stringValue]);
    vs.UPTaperMaxCount = TaperCountDefoultNum;
    self.LabelFrec.text = [NSString stringWithFormat:@"%.4f Hz",freq1];
    vs.flgDownTaper = 0;
    vs.flgUpTaper = 1;
    vs.UPTaperCount = 0;
    vs.frequency = freq1;
    vs.frequency2 = freq2;
    if (octSwitch == YES) {
        vs.frequency2 = freq1 * 2;
    }
    vs.nowPlaying = nowPlaying;
    vs.isplay = 1;
}

- (void)ToneGwave{
    [self changeFreq1:freqG Freq2:freqG NowPlaying:1];
}

-(void)ToneDwave{
    [self changeFreq1:freqD Freq2:freqD NowPlaying:2];
}

-(void)ToneAwave{
    [self changeFreq1:freqA Freq2:freqA NowPlaying:3];
}

-(void)ToneEwave{
    [self changeFreq1:freqE Freq2:freqE NowPlaying:4];
}

-(void)ToneGDwave{
    self.LabelFrec.text = @"GD";
    [self changeFreq1:freqG Freq2:freqD NowPlaying:5];
}

-(void)ToneDAwave{
    self.LabelFrec.text = @"DA";
    [self changeFreq1:freqD Freq2:freqA NowPlaying:6];
}

-(void)ToneAEwave{
    self.LabelFrec.text = @"AE";
    [self changeFreq1:freqA Freq2:freqE NowPlaying:7];
}

-(void)DownTaper{
    if (vs.isplay == 1) {
        vs.flgUpTaper = 0;
        vs.DownTaperCount = DownTaperDefoultNum;
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
    if (octSwitch == YES) {
        [self octBtnChangeColor];
    }
    NSLog(@"stopwave");
}

- (IBAction)ToneA:(id)sender {
    [self ToneButtonChangeColler:sender];
    if (vs.nowPlaying == 3 && vs.isplay == 1) {
        [self StopWave];
    }
    else{
        [self ToneAwave];
//        fft.SampleRate = frecA;
//        CGRect framesize = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200);
//        com_amakusaweb_meterView * mv = [[com_amakusaweb_meterView alloc] initWithFrame:framesize result:fftresult];
//
//        [self.view addSubview:mv];
        
        
       // [self performSegueWithIdentifier:@"segueFFT" sender:self];
    }
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
    NSLog(@"%ld",(long)[sender selectedSegmentIndex]);
    //オクターブ
    if ([sender selectedSegmentIndex ]== 3) {
        octSwitch = YES;
        Localwavetype = 1;
        _ToneGD.enabled = NO;
        _ToneDA.enabled = NO;
        _ToneAE.enabled = NO;
        [self octBtnChangeColor];
        if ((vs.nowPlaying == 5 || vs.nowPlaying == 6 || vs.nowPlaying == 7) && vs.isplay == 1) {
            [self StopWave];
        }else{
        
        [self ToneResume];
        }
    }else{//オクターブ以外
        octSwitch = NO;
        _ToneGD.enabled = YES;
        _ToneDA.enabled = YES;
        _ToneAE.enabled = YES;
        [self octBtnChangeColor];
        Localwavetype = (int)[sender selectedSegmentIndex] + 1;
        if (vs.isplay == 0) {
            vs.wavetype = Localwavetype;
        }else
            [self ToneResume];
    }
         
}

- (IBAction)helpButton:(UIButton *)sender {
    [self StopWave];
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
    if (octSwitch == YES) {
        [self octBtnChangeColor];
    }
    
    playing.backgroundColor = [UIColor colorWithRed:1.0 green:0.7 blue:1.0 alpha:1.0];
}
-(void)octBtnChangeColor{
    if (octSwitch == YES) {
        self.ToneGD.alpha = 0.3;
        self.ToneDA.alpha = 0.3;
        self.ToneAE.alpha = 0.3;
    }else{
        self.ToneGD.alpha = 1;
        self.ToneDA.alpha = 1;
        self.ToneAE.alpha = 1;
    }
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
@end
