//
//  IonHomeViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 28/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ionconstant.h"
#import <WaitSpinner.h>

@interface IonHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITabBar *HomeTabbar;
@property (nonatomic, strong) UIImageView * logo;
@property (weak, nonatomic) IBOutlet UITabBarItem *HomeTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *ListTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *SearchTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *ProfileTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *SttingsTab;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@end
