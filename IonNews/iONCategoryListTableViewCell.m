//
//  iONCategoryListTableViewCell.m
//  IonNews
//
//  Created by Augustin on 01/01/19.
//  Copyright © 2019 mantraLabsGlobal. All rights reserved.
//

#import "iONCategoryListTableViewCell.h"

@implementation iONCategoryListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.categoryView.layer.cornerRadius = 10;
    self.categoryView.layer.masksToBounds = YES;
    
    [self applyShadow];
}

- (void)applyShadow {
    // Add shadow
    [self.categoryView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [self.categoryView.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    [self.categoryView.layer setShadowRadius:5.0];
    [self.categoryView.layer setShadowOpacity:0.9];
    self.categoryView.clipsToBounds = YES;
    self.categoryView.layer.masksToBounds = NO;
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
