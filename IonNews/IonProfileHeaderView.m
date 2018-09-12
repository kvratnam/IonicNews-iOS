//
//  IonProfileHeaderView.m
//  IonNews
//
//  Created by Himanshu Rajput on 02/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonProfileHeaderView.h"
#import "Ionconstant.h"

@implementation IonProfileHeaderView


- (void)drawRect:(CGRect)rect {
//    self.layer.borderWidth = 0;
//    CALayer *border = [CALayer layer];
//    CGFloat borderWidth = 1;
//    border.borderColor = [UIColor lightGrayColor].CGColor;
//    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
//    border.borderWidth = borderWidth;
//    [self.layer addSublayer:border];
//    self.layer.masksToBounds = YES;

}


- (IBAction)likeBtnPressed:(id)sender {
    [[IonUtility sharedInstance] setIsLikeView:1];
    [self.delegate LikeButtonPrssed];
}

- (IBAction)storyBtnPressed:(id)sender {
    [[IonUtility sharedInstance] setIsLikeView:0];
    
    [self.delegate StoryButtonPressed];
    
}


@end
