//
//  IonNewsDetailVC.m
//  IonNews
//
//  Created by Himanshu Rajput on 07/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonNewsDetailVC.h"
#import "Ionconstant.h"

#define CONTENT_IDENTIFIER @"detailView"
#define FRAME_MARGIN	0
#define MIN_Limit		0


@interface IonNewsDetailVC ()

@property (assign, nonatomic) int previousIndex;
@property (assign, nonatomic) int tentativeIndex;
@property (assign, nonatomic) BOOL observerAdded;

@end

@implementation IonNewsDetailVC
{
    NSArray *updatedData;
}

@synthesize flipViewController = _flipViewController;
@synthesize frame = _frame;
@synthesize corkboard = _corkboard;
@synthesize previousIndex = _previousIndex;
@synthesize tentativeIndex = _tentativeIndex;


- (void)viewDidLoad
{
    [[IonUtility sharedInstance] setPageNumber:1];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.max_limit = self.totalPage;
    self.previousIndex = MIN_Limit;
    
    // Configure the page view controller and add it as a child view controller.
    self.flipViewController = [[MPFlipViewController alloc] initWithOrientation:[self flipViewController:nil orientationForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation]];
    self.flipViewController.delegate = self;
    self.flipViewController.dataSource = self;
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
//        pageViewRect = CGRectInset(pageViewRect, 0 + (hasFrame? FRAME_MARGIN : 0), 0 + (hasFrame? FRAME_MARGIN : 0));
       pageViewRect = CGRectInset(pageViewRect, 0 , 0 );
        self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    else
    {
//        pageViewRect = CGRectMake((self.view.bounds.size.width - 600)/2, (self.view.bounds.size.height - 600)/2, 600, 600);
        pageViewRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    self.flipViewController.view.frame = pageViewRect;
    [self addChildViewController:self.flipViewController];
    [self.view addSubview:self.flipViewController.view];
    [self.flipViewController didMoveToParentViewController:self];
    
    [self.flipViewController setViewController:[self contentViewWithIndex:self.previousIndex] direction:MPFlipViewControllerDirectionForward animated:NO completion:nil];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.flipViewController.gestureRecognizers;
    
    [self.corkboard setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern - Corkboard"]]];
    if (self.frame)
    {
        [self.frame setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern - Apple Wood"]]];
    }
    
    [self addObserver];

    
}

- (void)viewDidUnload
{
    [self setCorkboard:nil];
    [self setFrame:nil];
    [self removeObserver];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)addObserver
{
    if (![self observerAdded])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flipViewControllerDidFinishAnimatingNotification:) name:MPFlipViewControllerDidFinishAnimatingNotification object:nil];
        [self setObserverAdded:YES];
    }
}

- (void)removeObserver
{
    if ([self observerAdded])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPFlipViewControllerDidFinishAnimatingNotification object:nil];
        [self setObserverAdded:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self flipViewController])
        return [[self flipViewController] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    else
        return YES;
}


- (IonNewsDetailViewController *)contentViewWithIndex:(int)index
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IonNewsDetailViewController *page = [storyboard instantiateViewControllerWithIdentifier:CONTENT_IDENTIFIER];
    page.movieIndex = index;
    page.contentName = self.contentName;
    
    if (self.last_page > [[IonUtility sharedInstance] pageNumber] && [[IonUtility sharedInstance] pageNumber] <= self.last_page && index == [[IonUtility sharedInstance] newsData].count - 1) {
        [[IonUtility sharedInstance] setPageNumber:[[IonUtility sharedInstance] pageNumber]+1];
        [[requestHandler sharedInstance] storyListresponseMethod:nil viewcontroller:self category:self.category_id page:[[IonUtility sharedInstance] pageNumber] withHandler:^(id  _Nullable response) {
           page.category_id = self.category_id;
            updatedData = [response objectForKey:@"data"];
          
            if([updatedData isKindOfClass:[NSArray class]]){//December 04
                [[IonUtility sharedInstance] setNewsData:[[[IonUtility sharedInstance] newsData] arrayByAddingObjectsFromArray:updatedData]];
            }
            
 
            
        }];
        
    }else{
        page.category_id = self.category_id;
      //  page.newsData = self.newsData;
    }
    
    page.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return page;
}

#pragma mark - MPFlipViewControllerDelegate protocol

- (void)flipViewController:(MPFlipViewController *)flipViewController didFinishAnimating:(BOOL)finished previousViewController:(UIViewController *)previousViewController transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        self.previousIndex = self.tentativeIndex;
    }
}

- (MPFlipViewControllerOrientation)flipViewController:(MPFlipViewController *)flipViewController orientationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationIsPortrait(orientation)? MPFlipViewControllerOrientationVertical : MPFlipViewControllerOrientationHorizontal;
    else
        return MPFlipViewControllerOrientationHorizontal;
}

#pragma mark - MPFlipViewControllerDataSource protocol

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int index = self.previousIndex;
    index--;
    if (index < MIN_Limit)
        return nil; // reached beginning, don't wrap
    self.tentativeIndex = index;
    return [self contentViewWithIndex:index];
}

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index = self.previousIndex;
    index++;
    if (index > self.max_limit - 1)
        return nil; // reached end, don't wrap
    self.tentativeIndex = index;
    return [self contentViewWithIndex:index];	
}

#pragma mark - Notifications

- (void)flipViewControllerDidFinishAnimatingNotification:(NSNotification *)notification
{
    NSLog(@"Notification received: %@", notification);
}

@end
