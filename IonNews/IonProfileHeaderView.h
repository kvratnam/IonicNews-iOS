//
//  IonProfileHeaderView.h
//  IonNews
//
//  Created by Himanshu Rajput on 02/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IonProfileHeaderViewDelegate <NSObject>
-(void)LikeButtonPrssed;
-(void)StoryButtonPressed;

@end

@interface IonProfileHeaderView : UIView

@property(nonatomic, weak)id <IonProfileHeaderViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *likesLbl;
@property (weak, nonatomic) IBOutlet UILabel *storiesLbl;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *storiesCountLbl;


@end
