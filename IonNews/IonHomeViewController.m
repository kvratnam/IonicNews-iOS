//
//  IonHomeViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 28/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonHomeViewController.h"

@interface IonHomeViewController ()<IonHomeContentViewControllerdelegate, IonHomeProfileViewControllerdelegate>

@end

@implementation IonHomeViewController{

    CGPoint lastContentOffset;
    IonHomeContentViewController *IonHomeContentVC;
   // UIImageView *logo;
}

- (void)viewDidLoad {
    CGRect frame = self.scrollView.bounds;
    IonHomeProfileViewController *IonHomeProfileVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IonHomeProfileViewController"];
    IonHomeProfileVC.delegate = self;
    [self addChildViewController:IonHomeProfileVC];
    [self.scrollView addSubview:IonHomeProfileVC.view];
    [self didMoveToParentViewController:IonHomeProfileVC];
    IonHomeProfileVC.view.frame = frame;
     IonHomeContentVC= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"homeContentView"];
    IonHomeContentVC.delegate = self;
    
    frame.origin.x = self.view.frame.size.width;
    IonHomeContentVC.view.frame = frame;
    
    [self addChildViewController:IonHomeContentVC];
    [self.scrollView addSubview:IonHomeContentVC.view];
    [self didMoveToParentViewController:IonHomeContentVC];
    
    self.scrollView.contentSize = CGSizeMake(2*self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    
    
    
    self.logo = [[UIImageView alloc] init];
    self.logo.frame = CGRectMake(self.view.frame.size.width,0, 80, 80);
    self.logo.image = [UIImage imageNamed:@"logo"];
    self.logo.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:self.logo];
    self.logo.hidden = YES;
    
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
    
    }
}


#pragma mark - custom delegate and methods

-(void)setcontentoffset{
[self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)moveToHomeProfile{
[self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}

-(void)moveToContentView{

[self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
}
@end
