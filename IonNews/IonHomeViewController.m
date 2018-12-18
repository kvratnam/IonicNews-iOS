//
//  IonHomeViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 28/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonHomeViewController.h"
#import "IonSearchContentViewController.h"
#import "IonSettingViewController.h"
//#import "FIREv"

@interface IonHomeViewController ()<IonHomeContentViewControllerdelegate, IonHomeProfileViewControllerdelegate,UITabBarDelegate>

@end

@implementation IonHomeViewController{

    CGPoint lastContentOffset;
    IonHomeContentViewController *IonHomeContentVC;
    IonProfileViewController *ionProfileVC;
    IonSearchContentViewController * iONSearchVC;
    IonSettingViewController * iONSettingsVC;
   // UIImageView *logo;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [self.HomeTab setEnabled:YES];
//    [self.HomeTabbar.items[0] setEnabled:YES];

    if (self.scrollView.contentOffset.x == 0) {
        [self.HomeTabbar setSelectedItem:self.HomeTab];
    }else if (self.scrollView.contentOffset.x == self.view.frame.size.width) {
        [self.HomeTabbar setSelectedItem:self.ListTab];
    }else if (self.scrollView.contentOffset.x == self.view.frame.size.width*2) {
        [self.HomeTabbar setSelectedItem:self.SearchTab];
    }else if (self.scrollView.contentOffset.x == self.view.frame.size.width*3) {
        [self.HomeTabbar setSelectedItem:self.ProfileTab];
    }else if (self.scrollView.contentOffset.x == self.view.frame.size.width*4) {
        [self.HomeTabbar setSelectedItem:self.SttingsTab];
    }
    
    
}
- (void)viewDidLoad {
    CGRect frame = self.scrollView.bounds;
    
    IonHomeContentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"homeContentView"];
    IonHomeContentVC.delegate = self;
    IonHomeContentVC.view.frame = frame;
    [self addChildViewController:IonHomeContentVC];
    [self.scrollView addSubview:IonHomeContentVC.view];
    [self didMoveToParentViewController:IonHomeContentVC];
    
    IonHomeProfileViewController *IonHomeProfileVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IonHomeProfileViewController"];
    IonHomeProfileVC.delegate = self;
    frame.origin.x = self.view.frame.size.width;
    [self addChildViewController:IonHomeProfileVC];
    [self.scrollView addSubview:IonHomeProfileVC.view];
    [self didMoveToParentViewController:IonHomeProfileVC];
    IonHomeProfileVC.view.frame = frame;
    
    iONSearchVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IonSearchContentViewController"];
    iONSearchVC.delegate = self;
    frame.origin.x = self.view.frame.size.width * 2;
    [self addChildViewController:iONSearchVC];
    [self.scrollView addSubview:iONSearchVC.view];
    [self didMoveToParentViewController:iONSearchVC];
    iONSearchVC.view.frame = frame;
    
    
    
    ionProfileVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profileView"];
//    ionProfileVC.delegate = self;
    frame.origin.x = self.view.frame.size.width * 3;
    ionProfileVC.view.frame = frame;
    
    [self addChildViewController:ionProfileVC];
    [self.scrollView addSubview:ionProfileVC.view];
//    [self didMoveToParentViewController:ionProfileVC];
    
    
    iONSettingsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"settingVC"];
    //    ionProfileVC.delegate = self;
    frame.origin.x = self.view.frame.size.width * 4;
    iONSettingsVC.view.frame = frame;
    
    [self addChildViewController:iONSettingsVC];
    [self.scrollView addSubview:iONSettingsVC.view];
    
    
    
    self.scrollView.contentSize = CGSizeMake(5 * self.view.frame.size.width, self.view.frame.size.height - 49);
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    
    self.logo = [[UIImageView alloc] init];
    self.logo.frame = CGRectMake(self.view.frame.size.width,0, 80, 80);
    self.logo.image = [UIImage imageNamed:@"logo"];
    self.logo.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:self.logo];
    self.logo.hidden = YES;
    
    NSLog(@"Cotent Offset: %@",NSStringFromCGRect(self.scrollView.frame));

    
}


-(BOOL)prefersStatusBarHidden{
    
    return YES;
}


#pragma mark - scroll view delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
    CGPoint currentOffset = self.scrollView.contentOffset;
    CGFloat x,y,width,height;
    
    if (currentOffset.x > lastContentOffset.x && currentOffset.x <= self.view.frame.size.width)
    {
        x = (self.view.frame.size.width - 50)-((self.view.frame.size.width -200)-self.scrollView.contentOffset.x)/4 ;
        y = (self.view.frame.size.width - self.scrollView.contentOffset.x)/8;
        width = 30 - (((self.view.frame.size.width -200)-self.scrollView.contentOffset.x)/4);
        height = 30 - (((self.view.frame.size.width -200)-self.scrollView.contentOffset.x)/4);
        
        self.logo.frame = CGRectMake(x, y, width, height);

        
        lastContentOffset = currentOffset;
        
                NSLog(@"current off set here Upward %f %f %f", scrollView.contentOffset.x, y, ((self.view.frame.size.width -200)-scrollView.contentOffset.x)/2);
        
        // Upward
        
    }
    else if (currentOffset.x >= self.view.frame.size.width-200 && currentOffset.x <= self.view.frame.size.width ) {
        
        
        y = -(self.scrollView.contentOffset.x - self.view.frame.size.width)/8;
        width = 80 - (self.view.frame.size.width-self.scrollView.contentOffset.x)/4;
        x = self.view.frame.size.width - (self.view.frame.size.width-self.scrollView.contentOffset.x)/4;
        height = 80 - (self.view.frame.size.width-self.scrollView.contentOffset.x)/4;
        self.logo.frame = CGRectMake(x - 12, y-5, width, height);
               lastContentOffset = currentOffset;

        NSLog(@"current off set here Downward %f %f %f", scrollView.contentOffset.x ,y,x);
        // Downward
    }
}

    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
    
    CGPoint currentOffset = self.scrollView.contentOffset;
    CGPoint endingContentOffset;
    if (currentOffset.x > endingContentOffset.x && self.scrollView.contentOffset.x>= self.view.frame.size.width)
    {
        self.logo.frame = CGRectMake(self.view.frame.size.width, 0, 80, 80);
     endingContentOffset = currentOffset;
    }else{
        self.logo.frame = CGRectMake(self.view.frame.size.width - 62, 20, 30, 30);
     endingContentOffset = currentOffset;
    }
    
        if (self.scrollView.contentOffset.x == 0) {
            [self.HomeTabbar setSelectedItem:self.HomeTab];
        }else if (self.scrollView.contentOffset.x == self.view.frame.size.width) {
            [self.HomeTabbar setSelectedItem:self.ListTab];
        }else if (self.scrollView.contentOffset.x == self.view.frame.size.width*2) {
            [self.HomeTabbar setSelectedItem:self.SearchTab];
        }else if (self.scrollView.contentOffset.x == self.view.frame.size.width*3) {
            [self.HomeTabbar setSelectedItem:self.ProfileTab];
        }else if (self.scrollView.contentOffset.x == self.view.frame.size.width*4) {
            [self.HomeTabbar setSelectedItem:self.SttingsTab];
        }
        
    }
}


#pragma mark - custom delegate and methods

-(void)setcontentoffset{
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)moveToHomeProfile{
  
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    [self.HomeTabbar setSelectedItem:self.ListTab];

}

-(void)moveToContentView{

[self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
}

#pragma mark - Custom Tabbar Controllers Delegates

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    FIRAnalytics logEventWithName:kFIREventSelectContent
//parameters:@{
//             kFIRParameterItemID:[NSString stringWithFormat:@"id-%@", self.title],
//             kFIRParameterItemName:self.title,
//             kFIRParameterContentType:@"image"
//             }];
   
    if (item.tag ==  0) {
       
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if (item.tag == 1){
       
        [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        
    }else if (item.tag == 2){
        
        [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width * 2, 0) animated:YES];
        
    }else if (item.tag == 3){
        
    }else if (item.tag == 4){
        
        [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*3, 0) animated:YES];
        
    }else if (item.tag == 5){
        
        [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*4, 0) animated:YES];
        
    }
}

@end
