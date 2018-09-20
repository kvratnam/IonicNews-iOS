//
//  IonHomeContentViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 06/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IonHomeContentViewControllerdelegate <NSObject>

-(void)setcontentoffset;
-(void)moveToHomeProfile;

@end
@interface IonHomeContentViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property NSUInteger pageIndex;

@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *newsTitleCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *nameBackView;
@property (nonatomic,strong) NSString* contentName;
@property (weak, nonatomic) IBOutlet UIButton *nameLbl;
@property(nonatomic, weak)id<IonHomeContentViewControllerdelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *logo;


@end
