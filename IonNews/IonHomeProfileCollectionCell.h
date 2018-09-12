//
//  IonHomeProfileCollectionCell.h
//  IonNews
//
//  Created by Himanshu Rajput on 30/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IonHomeProfileCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForSubtitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForTitle;

@end
