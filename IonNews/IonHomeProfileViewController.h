//
//  IonHomeProfileViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 28/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IonHomeProfileViewControllerdelegate <NSObject>

-(void)moveToContentView;

@end

@interface IonHomeProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSArray *result;
@property(strong, nonatomic)NSDictionary *resultForStory;
@property(strong, nonatomic)NSMutableArray *titleForStory;
@property(nonatomic, weak)id<IonHomeProfileViewControllerdelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForHeaderConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForProfileImgConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthForProfileImgConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceFromTopConstant;
@property (weak, nonatomic) IBOutlet UIButton *profileImgButton;

@end

