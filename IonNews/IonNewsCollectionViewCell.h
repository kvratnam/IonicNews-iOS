//
//  IonNewsCollectionViewCell.h
//  IonNews
//
//  Created by Himanshu Rajput on 06/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IonNewsCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
-(void)addPanGesture;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfNewsTitle;
@property (weak, nonatomic) IBOutlet UILabel *refreshLabel;

@end
