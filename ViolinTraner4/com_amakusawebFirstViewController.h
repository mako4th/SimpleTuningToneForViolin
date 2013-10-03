//
//  com_amakusawebFirstViewController.h
//  ViolinTraner4
//
//  Created by 岡部 誠 on 2013/08/20.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@interface com_amakusawebFirstViewController : UIViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *LabelFrec;
@property (weak, nonatomic) IBOutlet UILabel *AfrecValue;
@property (weak, nonatomic) IBOutlet UIStepper *AfrecStepper;
@property (weak, nonatomic) IBOutlet UILabel *PitchLabel;
@property (weak, nonatomic) IBOutlet UIButton *ToneA;
@property (weak, nonatomic) IBOutlet UIButton *ToneD;
@property (weak, nonatomic) IBOutlet UIButton *ToneG;
@property (weak, nonatomic) IBOutlet UIButton *ToneE;
@property (weak, nonatomic) IBOutlet UIButton *Stop;
@property (weak, nonatomic) IBOutlet UIButton *ToneGD;
@property (weak, nonatomic) IBOutlet UIButton *ToneDA;
@property (weak, nonatomic) IBOutlet UIButton *ToneAE;
@property (weak, nonatomic) IBOutlet UILabel *AfrecHzLabel;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;


- (IBAction)ToneG:(id)sender;
- (IBAction)ToneD:(id)sender;
- (IBAction)ToneA:(id)sender;
- (IBAction)ToneE:(id)sender;
- (IBAction)ToneGD:(id)sender;
- (IBAction)ToneDA:(id)sender;
- (IBAction)ToneAE:(id)sender;
- (IBAction)selectWavetypeSegmentedC:(id)sender;

- (IBAction)AfrecStepper:(UIStepper *)sender;
- (IBAction)StopSound:(id)sender;

- (void)ToneGwave;
- (void)ToneDwave;
- (void)ToneAwave;
- (void)ToneEwave;
- (void)ToneGDwave;
- (void)ToneDAwave;
- (void)ToneAEwave;
- (void)StopWave;

- (void)ToneButtonChangeColler:(UIButton *)playing;


@end
