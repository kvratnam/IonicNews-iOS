//
//  iONCategoryListTableViewCell.h
//  IonNews
//
//  Created by Augustin on 01/01/19.
//  Copyright © 2019 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iONCategoryListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryDateTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryDateLbl;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryDescLbl;
@property (weak, nonatomic) IBOutlet UIView *categoryView;

@end
