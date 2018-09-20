//
//  IonMenuViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 11/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IonMenuViewControllerDelegate <NSObject>

-(void)likeButtonPressed;

@end


@interface IonMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (nonatomic, weak) id<IonMenuViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString* content_id;
@property (nonatomic, strong) NSString *crawl_url;
@end
