//
//  IonNewsDetailViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 06/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonNewsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Ionconstant.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define FRAME_MARGIN 10



@interface IonNewsDetailViewController ()<UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate,IonMenuViewControllerDelegate>

@property (assign, nonatomic, getter = isRotating) BOOL rotating;

@end

@implementation IonNewsDetailViewController{
    
    IonWebViewController *IonwebVC;
    IonMenuViewController *IonmenuVC;
    BOOL isLikeBool;
    Reachability *reachability;
    NetworkStatus internetStatus;
}

@synthesize ContentArea = _contentArea;
@synthesize ImageFrame = _imageFrame;
@synthesize ImageView = _imageView;
@synthesize DescriptionField = _descriptionField;
@synthesize newsTitle = _newsTitle;
@synthesize movieIndex = _movieIndex;
@synthesize rotating = _rotating;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProfileView" object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    reachability = [Reachability reachabilityForInternetConnection];
    internetStatus = [reachability currentReachabilityStatus];
    self.tagLabel.hidden = YES;
    //    [self.ImageFrame.layer setShadowOpacity:0.5];
    //    [self.ImageFrame.layer setShadowOffset:CGSizeMake(0, 1)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tap];
    IonwebVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webView"];
    IonmenuVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IonMenuViewController"];
    IonmenuVC.delegate = self;
    self.categoryName.text = [self.contentName uppercaseString];
    if ([self movieIndex] < [[IonUtility sharedInstance] newsData].count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:[[[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

            
            if ([[[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"type"] isEqualToString:@"news"]) {
                IonwebVC.crawl_url = [[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"crawl_url"];
                self.crawl_url = [[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"crawl_url"];
                self.likeBtn.hidden = NO;
                self.shareBtn.hidden = NO;
                self.menuBtn.hidden = NO;
            
            }else{
                self.likeBtn.hidden = YES;
                self.shareBtn.hidden = YES;
                self.menuBtn.hidden = YES;
                IonwebVC.crawl_url = [[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"custom_url"];
                self.crawl_url = [[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"custom_url"];
            }

            
            
            IonwebVC.category_id = self.category_id;
           
            self.content_id = [[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"id"];
            self.isLike = [[[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"islike"] intValue];
            
            
            IonwebVC.islike = self.isLike;
            if (self.isLike != 0) {
                [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            }else{
                [self.likeBtn setImage:[UIImage imageNamed:@"like_white"] forState:UIControlStateNormal];
                
            }
            
            IonwebVC.content_id = self.content_id;
            
            NSArray *arr = [self.crawl_url componentsSeparatedByString:@"/"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
            NSDate *updateDate = [df dateFromString:[[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"updated_at"]];
            
            
            if ((int)[[NSDate date] timeIntervalSinceDate:updateDate]/86400 == 0) {
                self.sourceLbl.text = [NSString stringWithFormat:@"%@ · %dh",[arr objectAtIndex:2],(int)[[NSDate date] timeIntervalSinceDate:updateDate]/3600];
            }else{
                if (arr.count == 1) {
                    self.sourceLbl.text = [arr objectAtIndex:0];
                }else{
                self.sourceLbl.text = [NSString stringWithFormat:@"%@ · %dd",[arr objectAtIndex:2],(int)[[NSDate date] timeIntervalSinceDate:updateDate]/86400];
                }
            }
            
           
//            [[ion_imageUrlrequest shared]setImageWithUrl:url withHandler:^(id  _Nullable image, NSError * _Nullable error) {
//                self.ImageView.backgroundColor = [UIColor colorWithRed:93.0/255.0 green:67.0/255.0 blue:147.0/255.0 alpha:1.0];
//                self.ImageView.image = image;
//                
//            }];
             self.ImageView.backgroundColor = [UIColor colorWithRed:93.0/255.0 green:67.0/255.0 blue:147.0/255.0 alpha:1.0];
            [self.ImageView sd_setImageWithURL:url placeholderImage:nil];
            
            
            self.DescriptionField.text = [[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"content"];
            self.newsTitle.text = [[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"title"];
            
            self.newsTag = [[[[IonUtility sharedInstance] newsData] objectAtIndex:[self movieIndex]] valueForKey:@"tags"];

            
            if ([self.newsTag isEqualToString:@""]) {
                self.tagLabel.hidden = YES;
            }else{
                            NSArray *newsTagArr = [self.newsTag componentsSeparatedByString:@"#"];
                
                self.tagLabel.hidden = NO;
                if (newsTagArr.count == 1) {
                    self.newsTag = [NSString stringWithFormat:@" #%@       ",[newsTagArr objectAtIndex:0]];
                }else{
                self.newsTag = [NSString stringWithFormat:@" #%@       ",[newsTagArr objectAtIndex:1]];
                }
                
            }
            self.tagLabel.text = [self.newsTag uppercaseString];
            [self.tagLabel intrinsicContentSize];
            
            
            UIFont *fontText = [UIFont fontWithName:@"SourceSerifPro-Regular" size:14];
            // you can use your font.
            
            CGSize maximumLabelSize = CGSizeMake(self.DescriptionField.frame.size.width, 150);
            
            CGRect textRect = [self.DescriptionField.text boundingRectWithSize:maximumLabelSize
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName:fontText}
                                                                       context:nil];
            
            CGSize     expectedLabelSize = CGSizeMake(textRect.size.width, textRect.size.height+10);
            
            self.heightForSubTitle.constant = expectedLabelSize.height;
            
            UIFont *fontText1 = [UIFont fontWithName:@"SourceSerifPro-Bold" size:24];
            CGSize maximumLabelSize1 = CGSizeMake(self.newsTitle.frame.size.width, 100);
            
            CGRect textRect1 = [self.newsTitle.text boundingRectWithSize:maximumLabelSize1
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:fontText1}
                                                                 context:nil];
            
            CGSize     expectedLabelSize1 = CGSizeMake(textRect1.size.width, textRect1.size.height+10);
            
            self.hightForTitle.constant = expectedLabelSize1.height;
            
            self.heightForImageView.constant = self.view.frame.size.height -(expectedLabelSize.height+expectedLabelSize1.height);
            
        });
    }
    
}


#pragma mark - transition delegate implementation

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    IonAnimation *transition = [[IonAnimation alloc] init];
    return transition;
    
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    id<UIViewControllerAnimatedTransitioning> transition;
    
//    if (self.interactive) {
//        transition = [[IonAnimatedDismissal alloc] init];
//    }else{
        transition = [[IonDismissalAnimation alloc] init];
//    }
    
    return transition;
    
}

//-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    
//    if (self.interactive) {
//        self.myInteractiveDismissal = [[UIPercentDrivenInteractiveTransition alloc] init];
//        return self.myInteractiveDismissal;
//    }
//    return nil;
//}
#pragma mark - menu delegate

-(void)likeButtonPressed{
    [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];

}

#pragma mark - action
- (IBAction)menuBtnPressed:(id)sender {
    
    IonmenuVC.content_id = self.content_id;
    IonmenuVC.crawl_url = self.crawl_url;
    IonmenuVC.modalPresentationStyle = UIModalPresentationCustom;
    IonmenuVC.transitioningDelegate = self;
    IonmenuVC.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:IonmenuVC animated:YES completion:^{
//        UIPanGestureRecognizer *gesture;
//        gesture = [[UIPanGestureRecognizer alloc] init];
//        [gesture addTarget:self action:@selector(handleGesture:)];
//        [IonmenuVC.view addGestureRecognizer:gesture];
    }];
    
    
}

- (IBAction)backBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)likeBtnPressed:(id)sender {
    
    if (internetStatus != NotReachable) {
        if (self.content_id != nil) {
            NSDictionary * paramDict = @{
                                         @"content_id" : self.content_id,
                                         };
            
            
            [[requestHandler sharedInstance] storyLikeresponseMethod:paramDict viewcontroller:self withHandler:^(id  _Nullable response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (response!= nil) {
                        
                        if (self.isLike !=0) {
                            if (isLikeBool == 0) {
                                [self.likeBtn setImage:[UIImage imageNamed:@"like_white"] forState:UIControlStateNormal];
                                isLikeBool = 1;
                            }else{
                                [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                                isLikeBool = 0;
                            }
                            
                            
                        }else{
                            if (isLikeBool == 0) {
                                [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                                isLikeBool = 1;
                            }else{
                                [self.likeBtn setImage:[UIImage imageNamed:@"like_white"] forState:UIControlStateNormal];
                                isLikeBool = 0;
                            }
                        }
                    }
                    
                });
                
            }];
        }

    }else{
    
    }

    
}

- (IBAction)shareBtnPressed:(id)sender {
    
    NSLog(@"shareButton pressed");
    
    NSString *texttoshare = @"Check out this story: "; //this is your text string to share
    NSURL *url= [NSURL URLWithString:self.crawl_url];
    NSString *appname = @"ION News!";
    //    UIImage *imagetoshare = [UIImage imageNamed:@"notification"]; //this is your image to share
    NSArray *activityItems = @[texttoshare, url, appname];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (void)tapOnView:(UITapGestureRecognizer *)sender
{
    //do something
    [self presentViewController:IonwebVC animated:YES completion:nil];
}


#pragma mark - methods

//-(void)handleGesture: (UIPanGestureRecognizer *)gesture{
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:{
//            
//            self.interactive = YES;
//            [self dismissViewControllerAnimated:YES completion:^{
//                self.interactive = NO;
//            }];
//            break;
//        }
//        case UIGestureRecognizerStateChanged:{
//            UIView *view = gesture.view.superview;
//            CGPoint translation = [gesture translationInView:view];
//            CGFloat persentTransitioned = (translation.y/ (CGRectGetHeight(view.frame)));
//            [self.myInteractiveDismissal updateInteractiveTransition:persentTransitioned];
//            break;
//        }
//            
//            
//        case UIGestureRecognizerStateEnded:{
//            if (self.myInteractiveDismissal.percentComplete > 0.25) {
//                [self.myInteractiveDismissal finishInteractiveTransition];
//            }else{
//                [self.myInteractiveDismissal cancelInteractiveTransition];
//                
//            }
//            
//            
//            break;
//        }
//            
//        case UIGestureRecognizerStateCancelled:{
//            
//            [self.myInteractiveDismissal cancelInteractiveTransition];
//            break;
//        }
//        default:
//            break;
//    }
//    
//    
//}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self setRotating:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    //    [self setShadowPathsWithAnimationDuration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self setRotating:NO];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    if (parent)
        NSLog(@"willMoveToParentViewController");
    else
        NSLog(@"willRemoveFromParentViewController");
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (parent)
        NSLog(@"didMoveToParentViewController");
    else
        NSLog(@"didRemoveFromParentViewController");
}

@end


