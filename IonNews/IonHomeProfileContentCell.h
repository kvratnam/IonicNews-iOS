//
//  IonHomeProfileContentCell.h
//  IonNews
//
//  Created by Himanshu Rajput on 30/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IonHomeProfileContentCellDelegate <NSObject>

-(void)presentViewController :(int)category_id title:(NSString *)title;

@end

@interface IonHomeProfileContentCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong, nonatomic)NSArray *result;
@property(strong, nonatomic)NSDictionary *resultForStory;
@property(strong, nonatomic)NSMutableArray *titlesForStory;
@property(nonatomic, weak)id<IonHomeProfileContentCellDelegate>delegate;
@property(strong, nonatomic)NSDictionary * resultCategoryList;

@end
