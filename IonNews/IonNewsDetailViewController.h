//
//  IonNewsDetailViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 06/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IonNewsDetailViewController : UIViewController



@property (assign, nonatomic) NSUInteger movieIndex;
@property (weak, nonatomic) IBOutlet UIView *ContentArea;
@property (weak, nonatomic) IBOutlet UIView *ImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UITextView *DescriptionField;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (nonatomic,assign) int category_id;
@property (nonatomic,strong) NSString* content_id;
@property (nonatomic,strong) NSString* contentName;
@property(nonatomic, assign) int isLike;
@property (nonatomic, strong) NSString *crawl_url;
@property (nonatomic, strong) NSString *newsTag;
@property (weak, nonatomic) IBOutlet UILabel *sourceLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForSubTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightForTitle;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *myInteractiveDismissal;
@property(assign, nonatomic) BOOL interactive;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthForTagLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;


@end
