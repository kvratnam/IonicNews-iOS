//
//  UITextField+addition.m
//  IonNews
//
//  Created by Himanshu Rajput on 21/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "UITextField+addition.h"

@implementation UITextField (addition)

-(void)designTextField {
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderWidth = 0;
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    border.borderWidth = borderWidth;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
    [[UITextField appearance] setTintColor:[UIColor redColor]];
}

@end
