//
//  iONHomeContentTableViewCell.m
//  IonNews
//
//  Created by Augustin on 20/12/18.
//  Copyright © 2018 mantraLabsGlobal. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "iONHomeContentTableViewCell.h"

@implementation iONHomeContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.homeView.layer.cornerRadius = 10;
    self.homeView.layer.masksToBounds = YES;
    
    self.expandableView.layer.cornerRadius = 10;
    self.expandableView.layer.masksToBounds = YES;
    
    self.showHideBtn.layer.cornerRadius = 12.5;
    self.showHideBtn.layer.masksToBounds = YES;
    self.showHideBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.showHideBtn.layer.borderWidth = 1.0;
    
    [self applyShadow];
    
    
    
}

- (void)applyShadow {
    // Add shadow
    [self.homeView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [self.homeView.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    [self.homeView.layer setShadowRadius:5.0];
    [self.homeView.layer setShadowOpacity:0.9];
    self.homeView.clipsToBounds = YES;
    self.homeView.layer.masksToBounds = NO;
    
    [self.expandableView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [self.expandableView.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.expandableView.layer setShadowRadius:8.0];
    [self.expandableView.layer setShadowOpacity:0.8];
    self.expandableView.clipsToBounds = YES;
    self.expandableView.layer.masksToBounds = NO;
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
