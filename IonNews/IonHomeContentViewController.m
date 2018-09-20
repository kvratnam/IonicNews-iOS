//
//  IonHomeContentViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 06/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonHomeContentViewController.h"
#import "Ionconstant.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface IonHomeContentViewController ()
@property (nonatomic, assign) CGFloat previousOffset;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic) CGFloat lastContentOffset;


@end

@implementation IonHomeContentViewController{
    NSDictionary *result;
    NSMutableArray*titles;
    NSIndexPath *indexPathAlreadySelected,* selectedIndex;
    IonNewsTitleCollectionViewCell* previousSelectedCell;
    int titleCellselected;
    int pageNumber;
    int pageNumberForTitle;
    float alphaValue;
    CGSize sizeforTitle;
    Reachability *reachability;
    NetworkStatus internetStatus;
    NSMutableDictionary *ArrangeDict;
    NSMutableArray *sortedTitles;
    NSMutableArray *sortedObject;
}

- (void)viewDidLoad {
    
    sortedTitles = [[NSMutableArray alloc] init];
    sortedObject = [[NSMutableArray alloc] init];
    ArrangeDict = [[ NSMutableDictionary alloc] init];
    titles = [[NSMutableArray alloc] init];
    self.nameBackView.layer.cornerRadius = 15.0;
    titleCellselected = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pulltoRefresh) name:@"updateHomeScreen" object:nil];
    reachability = [Reachability reachabilityForInternetConnection];
    internetStatus = [reachability currentReachabilityStatus];
    [self apiCall];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityCheck:)
                                                 name:@"networkConnectivity"
                                               object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityCheck:) name:kReachabilityChangedNotification object:nil];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [self.nameLbl setTitle:[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_detail"] objectForKey:@"first_name"] substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
    
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

#pragma mark - scrollview

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.newsCollectionView.frame.size.width;
    
    pageNumberForTitle = (int)((self.newsCollectionView.contentOffset.x) /pageWidth);
    NSLog(@"pagenumber for title %d",pageNumberForTitle);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    CGFloat pageWidth = self.newsCollectionView.frame.size.width - 30;
    pageNumber = (int)((self.newsCollectionView.contentOffset.x) /pageWidth);
    NSLog(@"%d %f %f",pageNumber,(self.newsCollectionView.contentOffset.x - 30*pageNumber), pageWidth);
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:pageNumber inSection:0];
    selectedIndex = indexpath;
    
    if (scrollView == self.newsCollectionView) {
        
        [self.newsTitleCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        [self.newsCollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        //This will move the underline
        
        [self.newsTitleCollectionView reloadData];
    }
    indexPathAlreadySelected = indexpath;
    
    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (self.lastContentOffset > scrollView.contentOffset.x && pageNumber == 0)
    {
        [self.delegate setcontentoffset];
        
    }
    
    //   CGSize size = CGSizeMake([[titles objectAtIndex:pageNumberForTitle] length]*22, 50);
    
    
    if([scrollView isEqual:self.newsCollectionView]) {
        CGPoint offset = self.newsTitleCollectionView.contentOffset;
        //        NSLog(@"content offset for new cell %f %f",offset.x, self.newsTitleCollectionView.frame.size.width);
        //        if (pageNumberForTitle >= 1) {
        //            offset.x = self.newsCollectionView.contentOffset.x*(size.width/self.newsTitleCollectionView.frame.size.width) - (size.width);
        //        }else{
        //         offset.x = self.newsCollectionView.contentOffset.x*(size.width/self.newsTitleCollectionView.frame.size.width);
        //        }
        
        //        offset.x = offset.x+(size.width/2.0);
        //  [self.newsTitleCollectionView setContentOffset:offset];
        self.newsTitleCollectionView.contentOffset = offset;
    }
    
    //    else {
    //        CGPoint offset = self.newsCollectionView.contentOffset;
    //        offset.x = self.newsTitleCollectionView.contentOffset.x;
    //        [self.newsCollectionView setContentOffset:offset];
    //    }
    
    //   NSLog(@"currentoffSet here %f %f %f", scrollView.contentOffset.x,self.newsTitleCollectionView.contentOffset.x, size.width);
}


#pragma mark - collectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.newsTitleCollectionView) {
        return [titles count];
    }
    return [result count];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (collectionView == self.newsCollectionView) {
        
        size = CGSizeMake(self.view.frame.size.width, collectionView.bounds.size.height);
    }else {
        size = CGSizeMake([[sortedTitles objectAtIndex:indexPath.row] length]*22, 50);
        sizeforTitle = CGSizeMake([[titles objectAtIndex:indexPath.row] length]*22, 50);
        //size = CGSizeMake(self.view.frame.size.width/2 - 10, 100);
    }
    
    return size;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (collectionView == self.newsCollectionView) {
        static NSString *cellIdentifier = @"newsImageCell";
        
        IonNewsCollectionViewCell *IonNewscell = [self.newsCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        //
        [IonNewscell addPanGesture];
        if (internetStatus != NotReachable) {
            IonNewscell.newsTitle.text = [[[sortedObject objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"title"];
        }else{
            IonNewscell.newsTitle.text = [[[result valueForKey:[titles objectAtIndex:indexPath.row]] objectAtIndex:0] valueForKey:@"title"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //  NSString *url = [[[result valueForKey:[titles objectAtIndex:indexPath.row]] objectAtIndex:0] valueForKey:@"image"];
            NSString *url;
            if (internetStatus != NotReachable) {
                url = [[[sortedObject objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"image"];
            }else{
                url = [[[result valueForKey:[titles objectAtIndex:indexPath.row]] objectAtIndex:0] valueForKey:@"image"];
            }
            
            NSString* webStringURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL * URL = [NSURL URLWithString:webStringURL];
            //            [[ion_imageUrlrequest shared]setImageWithUrl:URL withHandler:^(id  _Nullable image, NSError * _Nullable error) {
            //                IonNewscell.newsImageView.image = image;
            //
            //                // [cell.newsImageView designImageView];
            //            }];
            [IonNewscell.newsImageView sd_setImageWithURL:URL placeholderImage:nil];
            
        });
        
        
        return IonNewscell;
        
    }else if (collectionView == self.newsTitleCollectionView){
        static NSString *cellIdentifier = @"newsTitleCell";
        
        IonNewsTitleCollectionViewCell *cell = [self.newsTitleCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        // cell.newsTitle.text = [[titles objectAtIndex:indexPath.row] uppercaseString];
        cell.newsTitle.text = [[sortedTitles objectAtIndex:indexPath.row] uppercaseString];
        [cell.newsTitle sizeToFit];
        
        
        
        
        if (cell.selected || titleCellselected == 1) {
            [self showSelectedTitle:cell];
            titleCellselected = 0;
            previousSelectedCell = cell;
        }else if (indexPath == indexPathAlreadySelected) {
            [self showSelectedTitle:cell];
            
        }else{
            [self hideSelectedTitle:cell];
        }
        
        
        return cell;
        
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.newsTitleCollectionView) {
        IonNewsTitleCollectionViewCell* cell = (IonNewsTitleCollectionViewCell *)[collectionView  cellForItemAtIndexPath:indexPath];
        
        [self hideSelectedTitle:previousSelectedCell];
        previousSelectedCell = cell;
        if (indexPath.row == titles.count-1) {
            self.newsTitleCollectionView.userInteractionEnabled = NO;
        }else{
            self.newsTitleCollectionView.userInteractionEnabled = YES;
            [self.newsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
            
            [self.newsTitleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self showSelectedTitle:cell];
        }
        
    }else{
        
        IonNewsDetailVC *IonDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailVC"];
        
        //  NSNumber * num = [[[result valueForKey:[titles objectAtIndex:indexPath.row]] objectAtIndex:0] objectForKey:@"category_id"];
        NSNumber * num;
        if (internetStatus != NotReachable) {
            num = [[[sortedObject objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"category_id"];
        }else{
            num = [[[result valueForKey:[titles objectAtIndex:indexPath.row]] objectAtIndex:0] objectForKey:@"category_id"];
        }
        
        IonDetailVC.category_id = [num intValue];
        IonDetailVC.contentName = [sortedTitles objectAtIndex:indexPath.row];
        if (internetStatus != NotReachable) {
            [[requestHandler sharedInstance] storyListresponseMethod:nil viewcontroller:self category:[num intValue] page:1 withHandler:^(id  _Nullable response) {
                [[IonUtility sharedInstance] setNewsData:[[response objectForKey:@"data"] objectForKey:@"all_data"]];
                IonDetailVC.last_page = [[response objectForKey:@"last_page"] intValue];
                IonDetailVC.totalPage = [[[response objectForKey:@"data"] objectForKey:@"total_Count"]intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:IonDetailVC animated:YES completion:nil];
                });
                NSLog(@"self.newsdata here %@",[[IonUtility sharedInstance] newsData]);
                
            }];
        }else{
            
            [[IonUtility sharedInstance] setNewsData:[result objectForKey:[titles objectAtIndex:indexPath.row]]];
            NSArray *arr = [result objectForKey:[titles objectAtIndex:indexPath.row]];
            NSLog(@"count for articles %lu",(unsigned long)arr.count);
            IonDetailVC.totalPage = (int)arr.count;
            //[[IonUtility sharedInstance] setNewsData:[sortedObject objectAtIndex:indexPath.row]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:IonDetailVC animated:YES completion:nil];
            });
        }
        
        
        
        [[IonUtility sharedInstance] setIsFromProfileView:@"NO"];
        
    }
    
};

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.newsTitleCollectionView) {
        IonNewsTitleCollectionViewCell* cell = (IonNewsTitleCollectionViewCell *)[collectionView  cellForItemAtIndexPath:indexPath];
        [self hideSelectedTitle:cell];
        
    }
    
}




- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.newsTitleCollectionView) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        
        return UIEdgeInsetsMake(0, 16, 0, 16);
    }
}


#pragma mark - methods


-(void)showSelectedTitle:(IonNewsTitleCollectionViewCell *)cell
{
    cell.newsTitle.textColor = [UIColor blackColor];
}

-(void)hideSelectedTitle:(IonNewsTitleCollectionViewCell *)cell
{
    cell.newsTitle.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.1];
    
}

-(void)reachabilityCheck:(NSNotification *)notification{
    
    NSString *reachabilityStatus = [notification object];
    if ([reachabilityStatus isEqualToString:@"YES"]) {
        [[requestHandler sharedInstance] homePageStoryresponseMethod:nil viewcontroller:self withHandler:^(id response) {
            result = response;
            NSLog(@"home screen response %@", result);
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                titles =[result allKeys].mutableCopy;
                
                [[DBManager getSharedInstance] deleteAllRows];
                
                for (int i=0; i< titles.count ; i++) {
                    NSArray *articleDetail = [result valueForKey:[titles objectAtIndex:i]];
                    NSLog(@"value for title %lu", (unsigned long)articleDetail.count);
                    
                    for (int j=0; j < articleDetail.count; j++) {
                        
                        [[DBManager getSharedInstance] saveData:[titles objectAtIndex:i] title:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:j] valueForKey:@"title"] content:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:j] valueForKey:@"content"] image:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:j] valueForKey:@"image"] crawl_url:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:j] valueForKey:@"crawl_url"]];
                    }
                }
                
                
                [titles addObject:@"         "];
                indexPathAlreadySelected = 0;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_newsCollectionView reloadData];
                    [_newsTitleCollectionView reloadData];
                    [[IonCustomActivityIndicator sharedInstance] activityIndicatorDismiss:self.view];
                });
            });
            
        }];
    }else{
        NSDictionary *sqliteData = [[DBManager getSharedInstance] ArrangeData];
        result = sqliteData;
        titles = [result allKeys].mutableCopy;
        [titles addObject:@"         "];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_newsCollectionView reloadData];
            [_newsTitleCollectionView reloadData];
            [[IonCustomActivityIndicator sharedInstance] activityIndicatorDismiss:self.view];
        });
        NSLog(@"array of sqlite %@", sqliteData);
        
    }
}

-(void)apiCall{
    [[IonCustomActivityIndicator sharedInstance] acitivityIndicatorPresent:self.view];
    if (internetStatus != NotReachable) {
        self.newsCollectionView.userInteractionEnabled = false;
        
        [[requestHandler sharedInstance] homePageStoryresponseMethod:nil viewcontroller:self withHandler:^(id response) {
            
            if (response != nil) {
                [titles removeAllObjects];
                [ArrangeDict removeAllObjects];
                result = response;
                
                NSLog(@"home screen response %@", result);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    if (![[result valueForKey:@"status"]  isEqual: @"No Story"]) {
                        
                        titles =[[result allKeys] mutableCopy];
                        
                        [[DBManager getSharedInstance] deleteAllRows];
                        
                        for (int i=0; i< titles.count ; i++) {
                            
                            [ArrangeDict setValue:[titles objectAtIndex:i] forKey:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:0] valueForKey:@"priority"]];
                            
                            NSArray *articleDetail = [result valueForKey:[titles objectAtIndex:i]];
                            NSLog(@"value for title %lu", (unsigned long)articleDetail.count);
                            NSArray  *priority= [[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:0] valueForKey:@"priority"];
                            NSLog(@"priority order for home response %@", priority);
                            
                            for (int j=0; j < articleDetail.count; j++) {
                                
                                [[DBManager getSharedInstance] saveData:[titles objectAtIndex:i] title:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:j] valueForKey:@"title"] content:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:j] valueForKey:@"content"] image:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:j] valueForKey:@"image"] crawl_url:[[[result valueForKey:[titles objectAtIndex:i]] objectAtIndex:j] valueForKey:@"crawl_url"]];
                            }
                        }
                        
                        NSArray *sortedKeys = [[ArrangeDict allKeys] sortedArrayUsingSelector: @selector(compare:)];
                        //  NSMutableDictionary *sortedDict = [[NSMutableDictionary alloc] init];
                        [sortedTitles removeAllObjects];
                        [sortedObject removeAllObjects];
                        for (NSString *key in sortedKeys)
                            [sortedTitles addObject: [ArrangeDict objectForKey: key]];
                        for (int i=0; i< sortedTitles.count; i++) {
                            //                    [sortedDict setObject:[result valueForKey:[sortedValues objectAtIndex:i]] forKey:[sortedValues objectAtIndex:i]];
                            [sortedObject insertObject:[result valueForKey:[sortedTitles objectAtIndex:i]] atIndex:i];
                        }
                        
                        
                        NSLog(@"print arrangeDict  %@ %@ %@ %@", ArrangeDict, sortedKeys, sortedTitles , sortedObject);
                        [titles addObject:@"         "];
                        [sortedTitles addObject:@"         "];
                        indexPathAlreadySelected = 0;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [_newsCollectionView reloadData];
                            [_newsTitleCollectionView reloadData];
                            
                            
                        });
                        
                    }
                    
                });
            }
            
            [[IonCustomActivityIndicator sharedInstance] activityIndicatorDismiss:self.view];
            self.newsCollectionView.userInteractionEnabled = true;
        }];
    }else{
        NSDictionary *sqliteData = [[DBManager getSharedInstance] ArrangeData];
        result = sqliteData;
        sortedTitles = [result allKeys].mutableCopy;
        [sortedTitles addObject:@"         "];
        titles = [result allKeys].mutableCopy;
        [titles addObject:@"         "];
        NSLog(@"array of sqlite %@", sqliteData);
        
        
    }
    
    
}


#pragma mark - action

-(void)pulltoRefresh{
    //    [self.newsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //    [self.newsTitleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self apiCall];
}


- (IBAction)menuBtnPressed:(id)sender {
    [[IonUtility sharedInstance] setIsLikeView:0];
    [[IonUtility sharedInstance] setIsFromProfileView:@"NO"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuButtonPressed" object:nil];
    [self.delegate moveToHomeProfile];
}

- (IBAction)profileBtnPressed:(id)sender {
    
    NSDictionary *result = [[DBManager getSharedInstance] ArrangeData];
    
    NSLog(@"array of sqlite %@", result);
    [self.delegate moveToHomeProfile];
    
}

@end
