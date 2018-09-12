//
//  IonCustomActivityIndicator.m
//  IonNews
//
//  Created by Himanshu Rajput on 15/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonCustomActivityIndicator.h"

@implementation IonCustomActivityIndicator
{
    UIActivityIndicatorView *spinner;

}


+(IonCustomActivityIndicator *)sharedInstance{
    static IonCustomActivityIndicator *this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      this = [[self alloc] init];
     });
    return this;
}


-(void)acitivityIndicatorPresent:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //spinner.center = view.center;
        [spinner setCenter:CGPointMake(view.frame.size.width/2,view.frame.size.height/2)];
        [view addSubview:spinner];
        [view bringSubviewToFront:spinner];
        [spinner startAnimating];
    });
}

-(void)activityIndicatorDismiss:(UIView *)view{
    [spinner removeFromSuperview];
    [spinner stopAnimating];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
