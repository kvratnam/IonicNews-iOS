//
//  IonCustomActivityIndicator.h
//  IonNews
//
//  Created by Himanshu Rajput on 15/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IonCustomActivityIndicator : UIView

+(IonCustomActivityIndicator * _Nullable)sharedInstance;


-(void)acitivityIndicatorPresent:(UIView *_Nullable)view;
-(void)activityIndicatorDismiss:(UIView *_Nullable)view;

@end
