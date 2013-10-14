//
//  com.amakusawebhelpViewController.h
//  TuningTone
//
//  Created by 岡部 誠 on 2013/10/02.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface com_amakusawebhelpViewController : UIViewController <UIWebViewDelegate>
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *HelpView;
@end
