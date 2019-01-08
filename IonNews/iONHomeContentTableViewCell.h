//
//  iONHomeContentTableViewCell.h
//  IonNews
//
//  Created by Augustin on 20/12/18.
//  Copyright © 2018 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iONHomeContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryType;
@property (weak, nonatomic) IBOutlet UIView *homeView;
@property (weak, nonatomic) IBOutlet UIView *expandableView;
@property (weak, nonatomic) IBOutlet UIImageView *expSelectionImage;
@property (weak, nonatomic) IBOutlet UILabel *expTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *expTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *expImage;
@property (weak, nonatomic) IBOutlet UILabel *expSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *expDescLbl;
@property (weak, nonatomic) IBOutlet UIButton *showHideBtn;

@end
