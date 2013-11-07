//
//  com.amakusawebhelpViewController.m
//  TuningTone
//
//  Created by 岡部 誠 on 2013/10/02.
//  Copyright (c) 2013年 MAKOTO OKABE. All rights reserved.
//

#import "com.amakusawebhelpViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface com_amakusawebhelpViewController ()

@end

@implementation com_amakusawebhelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        NSLog(@"ios7以上");
        _nBar.frame = CGRectOffset(_nBar.frame, 0, 20);
        _wView.frame = CGRectMake(_wView.frame.origin.x, _wView.frame.origin.y + 20, _wView.frame.size.width, _wView.frame.size.height-20);
    }else{
        NSLog(@"ios7以下");
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.HelpView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL: [request URL]];
        return NO;
    }
    
    return YES;
}

@end
