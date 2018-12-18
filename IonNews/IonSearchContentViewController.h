//
//  IonSearchContentViewController.h
//  IonNews
//
//  Created by Augustin on 27/09/18.
//  Copyright © 2018 Augustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IonHomeProfileViewControllerdelegate <NSObject>

-(void)moveToContentView;

@end

@interface IonSearchContentViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSArray *result;
@property(strong, nonatomic)NSDictionary *resultForStory;
@property(strong, nonatomic)NSMutableArray *titleForStory;
@property(strong, nonatomic)NSMutableArray *searchTitleStory;
@property(nonatomic, weak)id<IonHomeProfileViewControllerdelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForHeaderConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForProfileImgConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthForProfileImgConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceFromTopConstant;
@property (weak, nonatomic) IBOutlet UIButton *profileImgButton;
- (IBAction)searchCancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong, nonatomic)NSArray *resultCategory;
@property(strong, nonatomic)NSMutableArray *searchResultCategory;
@property(strong, nonatomic)NSArray *resultTag;
@property(strong, nonatomic)NSMutableArray *searchResultTag;
@property(strong, nonatomic)NSDictionary * resultCategoryList;
@property(strong, nonatomic)NSDictionary * resultTagList;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;

@end
