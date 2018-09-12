//
//  IonNewsDetailVC.h
//  IonNews
//
//  Created by Himanshu Rajput on 07/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFlipViewController.h"
#import "IonNewsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface IonNewsDetailVC : UIViewController<MPFlipViewControllerDelegate, MPFlipViewControllerDataSource>

@property (strong, nonatomic) MPFlipViewController *flipViewController;
@property (weak, nonatomic) IBOutlet UIView *corkboard;
@property (weak, nonatomic) IBOutlet UIView *frame;
@property (nonatomic,assign) int max_limit;
@property (nonatomic,assign) int category_id;
@property (nonatomic,strong) NSString* contentName;
@property (nonatomic,assign) int last_page;
@property (nonatomic,assign) int totalPage;
//@property (nonatomic, strong) NSMutableArray *newsData;

@end
