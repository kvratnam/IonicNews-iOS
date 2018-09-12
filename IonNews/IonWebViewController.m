//
//  IonWebViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 13/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonWebViewController.h"
#import "Ionconstant.h"


@interface IonWebViewController ()<UIWebViewDelegate>

@end

@implementation IonWebViewController{
 BOOL isLikeBool;
}

- (void)viewDidLoad {
    
    [[IonCustomActivityIndicator sharedInstance] acitivityIndicatorPresent:self.view];
    self.webview.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:[self.crawl_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webview loadRequest:request];
    });
        if (self.islike != 0) {
       [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }else{
    [self.likeBtn setImage:[UIImage imageNamed:@"like_white"] forState:UIControlStateNormal];
    }
    [super viewDidLoad];
    
}

-(BOOL)prefersStatusBarHidden{

    return YES;
}


#pragma mark - webView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[IonCustomActivityIndicator sharedInstance] activityIndicatorDismiss:self.view];
}

#pragma mark - action

- (IBAction)likeBtnPressed:(id)sender {
    
    NSDictionary * paramDict = @{
                                 @"content_id" : self.content_id,
                                 };
    
    [[requestHandler sharedInstance] storyLikeresponseMethod:paramDict viewcontroller:self withHandler:^(id  _Nullable response) {
        if (self.islike!=0) {
            if (isLikeBool == 0) {
                [self.likeBtn setImage:[UIImage imageNamed:@"like_white"] forState:UIControlStateNormal];
                isLikeBool = 1;
            }else{
                [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                isLikeBool = 0;
            }
        }else{
            if (isLikeBool == 0) {
                [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                isLikeBool = 1;
            }else{
                [self.likeBtn setImage:[UIImage imageNamed:@"like_white"] forState:UIControlStateNormal];
                isLikeBool = 0;
            }
        }
    }];

    
}


- (IBAction)backBtnPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    });

}


- (IBAction)shareBtnPressed:(id)sender {
    
    NSLog(@"shareButton pressed");
    
    NSString *texttoshare = @"Check out this story: "; //this is your text string to share
    NSURL *url= [NSURL URLWithString:self.crawl_url];
    NSString *appname = @"ION News!";
    UIImage *imagetoshare = [UIImage imageNamed:@"notification"]; //this is your image to share
    NSArray *activityItems = @[texttoshare, url, appname, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];

    
}

@end
