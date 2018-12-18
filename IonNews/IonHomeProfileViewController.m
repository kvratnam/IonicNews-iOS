//
//  IonHomeProfileViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 28/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonHomeProfileViewController.h"
#import "Ionconstant.h"

@interface IonHomeProfileViewController ()<UITableViewDelegate,UITableViewDataSource, IonHomeProfileContentCellDelegate, IonProfileHeaderViewDelegate>


@end

@implementation IonHomeProfileViewController{
    
    CGFloat scrollOffset;
    IonProfileHeaderView *view;
    IonHomeProfileDetailCell *detailCell;
    CGPoint lastContentOffset;
    Reachability *reachability;
    NetworkStatus internetStatus;
    NSMutableDictionary *ArrangeDict;
    NSMutableArray * titles;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    view = [[[NSBundle mainBundle] loadNibNamed:@"IonHomeHeaderView" owner:self options:nil] objectAtIndex:0];
    self.heightForHeaderConstant.constant = 125;
    self.profileImgButton.layer.cornerRadius = self.profileImgButton.frame.size.width/2;
    self.profileImgButton.clipsToBounds = YES;
    ArrangeDict = [[ NSMutableDictionary alloc] init];
    titles = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(apiCall) name:@"updateProfileView" object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"updateProfileImg"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"updateProfileImg"] isEqualToString:@""]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * URL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"updateProfileImg"]];
            [[ion_imageUrlrequest shared]setImageWithUrl:URL withHandler:^(id  _Nullable image, NSError * _Nullable error) {
                [self.profileImgButton setBackgroundImage:image forState:UIControlStateNormal];
            }];
        });
        
    }
    reachability = [Reachability reachabilityForInternetConnection];
    internetStatus = [reachability currentReachabilityStatus];
    [self apiCall];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonPressed) name:@"MenuButtonPressed" object:nil];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityCheck:)
                                                 name:@"networkConnectivity"
                                               object:nil];
    
    
}

-(void)apiCall{

    if (internetStatus != NotReachable) {
        
        [[requestHandler sharedInstance] getallLikeresponseMethod:nil viewcontroller:self withHandler:^(id response) {
            self.result = [response objectForKey:@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //            [self.tableView reloadData];
                
            });
            
        }];
        
        [[requestHandler sharedInstance] homePageStoryresponseMethod:nil viewcontroller:self withHandler:^(id  _Nullable response) {
            self.resultForStory = response;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.titleForStory = [self.resultForStory allKeys].mutableCopy;
                titles = [self.resultForStory allKeys].mutableCopy;
                for (int i=0; i< titles.count ; i++) {
                    [ArrangeDict setValue:[titles objectAtIndex:i] forKey:[[[self.resultForStory valueForKey:[titles objectAtIndex:i]] objectAtIndex:0] valueForKey:@"id"]];
//                    NSArray *SortedKeys = [ArrangeDict keysSortedByValueUsingSelector:@selector(compare:)]; // Oct 26
                    NSArray *sortedKeys = [[ArrangeDict allKeys] sortedArrayUsingSelector: @selector(compare:)];
                    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compare:)];
                    NSArray* sortedArray = [sortedKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
                    NSLog(@"Home Profile VC: %@",sortedArray);
                    
                    
                    [self.titleForStory removeAllObjects];
                    for (NSString *key in sortedArray)
                        [self.titleForStory addObject: [ArrangeDict objectForKey: key]];
                }
                [self animateTableView:self.tableView];
                
            });
        }];
    }else{
        NSDictionary *sqliteData = [[DBManager getSharedInstance] ArrangeData];
        self.resultForStory = sqliteData;
        self.titleForStory = [self.resultForStory allKeys].mutableCopy;
        [self animateTableView:self.tableView];
        
    }

}

-(void)reachabilityCheck:(NSNotification *)notification{
    
    NSString *reachabilityStatus = [notification object];
    if ([reachabilityStatus isEqualToString:@"YES"]) {
        [[requestHandler sharedInstance] getallLikeresponseMethod:nil viewcontroller:self withHandler:^(id response) {
            self.result = [response objectForKey:@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //            [self.tableView reloadData];
                
            });
            
        }];
        
        [[requestHandler sharedInstance] homePageStoryresponseMethod:nil viewcontroller:self withHandler:^(id  _Nullable response) {
            self.resultForStory = response;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.titleForStory = [self.resultForStory allKeys].mutableCopy;;
                [self animateTableView:self.tableView];
                
                
            });
        }];
    }else{
        NSDictionary *sqliteData = [[DBManager getSharedInstance] ArrangeData];
        self.resultForStory = sqliteData;
        self.titleForStory = [self.resultForStory allKeys].mutableCopy;
        [self animateTableView:self.tableView];
        NSLog(@"array of sqlite %@", sqliteData);
        
    }
}


#pragma mark - scrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint currentOffset = scrollView.contentOffset;
    
    if (currentOffset.y > lastContentOffset.y && currentOffset.y <= 48)
    {
        
        //headerview for animatio
        self.heightForHeaderConstant.constant = 120 - scrollView.contentOffset.y;
        self.distanceFromTopConstant.constant = 58 - scrollView.contentOffset.y;
        self.heightForProfileImgConstant.constant = 60 - scrollView.contentOffset.y/2;
        self.widthForProfileImgConstant.constant = 60 - scrollView.contentOffset.y/2;;
        self.profileImgButton.layer.cornerRadius = (60 - scrollView.contentOffset.y/2)/2;
        
        lastContentOffset = currentOffset;
        //
        
        // Upward
        
    }
    else if (currentOffset.y <= 48 && currentOffset.y >= 0) {
        
        //headerview for animation
        
        self.distanceFromTopConstant.constant = 10 +(48 - scrollView.contentOffset.y);
        self.heightForHeaderConstant.constant = 72 + (48 - scrollView.contentOffset.y);
        
        if (currentOffset.y <= 24) {
            self.heightForProfileImgConstant.constant = 20+(48 - scrollView.contentOffset.y);
            self.widthForProfileImgConstant.constant = 20+(48 - scrollView.contentOffset.y);
            self.profileImgButton.layer.cornerRadius = (20+(48 - scrollView.contentOffset.y))/2;
        }
        
        lastContentOffset = currentOffset;
        //
        
        // Downward
    }
    
    
}


#pragma mark - tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    
    switch (indexPath.section) {
        case 0:
            height = 55;
            return height;
            break;
            
        case 1:
            if ([[IonUtility sharedInstance] isLikeView] == 1) {
                height = ceil((float) self.result.count/2)*(self.view.frame.size.width/2)+ceil((float) self.result.count/2)*10;
                
            }else{
                height = ceil((float) self.titleForStory.count/2)*(self.view.frame.size.width/2)+ceil((float) self.titleForStory.count/2)*10;
            }
            return height;
            break;
            
        default:
            height = 0;
            return height;
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        IonHomeProfileDetailCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"IonHomeProfileCell"];
        cell.userName.text = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_detail"] objectForKey:@"first_name"] uppercaseString];
        
        cell.userName.text = [[NSString stringWithFormat:@"%@ %@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_detail"] objectForKey:@"first_name"],[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_detail"] objectForKey:@"last_name"]] uppercaseString];
        
        return cell;
    }else{
        IonHomeProfileContentCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"IonHomeStoryCell"];
        if ([[IonUtility sharedInstance] isLikeView] == 1) {
            cell.result = self.result;
            
        }else{
            cell.resultForStory = self.resultForStory;
            cell.titlesForStory = self.titleForStory;
        }
        
        [cell.collectionView reloadData];
        cell.delegate = self;
        return cell;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view2 = [[UIView alloc] init];
        view2.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        view2.backgroundColor = [UIColor redColor];
        
        
        return view2;
        
    }else{
        
        view.delegate = self;
        
        view.likesCountLbl.text = [NSString stringWithFormat:@"%lu",self.result.count];
        view.storiesCountLbl.text = [NSString stringWithFormat:@"%lu",self.titleForStory.count];
        
        if ([[IonUtility sharedInstance] isLikeView] == 1) {
            view.likesCountLbl.textColor = [UIColor blackColor];
            view.likesLbl.textColor = [UIColor blackColor];
            view.storiesCountLbl.textColor = [UIColor lightGrayColor];
            view.storiesLbl.textColor = [UIColor lightGrayColor];
        }else{
            view.likesCountLbl.textColor = [UIColor lightGrayColor];
            view.likesLbl.textColor = [UIColor lightGrayColor];
            view.storiesCountLbl.textColor = [UIColor blackColor];
            view.storiesLbl.textColor = [UIColor blackColor];
        }
        
        
        return view;
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
            break;
            
        case 1:
            return 55;
            break;
            
        default:
            return 0;
            break;
    }
    
}


#pragma mark - custom delegate

-(void)presentViewController:(int)category_id title:(NSString *)title{
    
    
    IonNewsDetailVC *IonDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailVC"];
    
    //here i am am checking by a singleton object that is this view is accessing by profile view or content view
    if ([[[IonUtility sharedInstance] isFromProfileView] isEqualToString:@"YES"]) {
        [[requestHandler sharedInstance] getallLikeresponseMethod:nil viewcontroller:self withHandler:^(id  _Nullable response) {
            [[IonUtility sharedInstance] setNewsData:[response objectForKey:@"data"]];
            IonDetailVC.category_id = category_id;
            IonDetailVC.last_page = [[response objectForKey:@"last_page"] intValue];
            IonDetailVC.totalPage = [[response objectForKey:@"total"] intValue];
            IonDetailVC.contentName = @"Like";
            NSLog(@"self.newsdata here %@",[[IonUtility sharedInstance] newsData]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:IonDetailVC animated:YES completion:nil];
            });
            
        }];
        
    }else{
        
        [[requestHandler sharedInstance] storyListresponseMethod:nil viewcontroller:self category:category_id page:1 withHandler:^(id  _Nullable response) {
                        [[IonUtility sharedInstance] setNewsData:[[response objectForKey:@"data"] objectForKey:@"all_data"]];
            IonDetailVC.category_id = category_id;
            IonDetailVC.last_page = [[response objectForKey:@"last_page"] intValue];
            IonDetailVC.totalPage = [[[response objectForKey:@"data"] objectForKey:@"total_Count"]intValue];
            IonDetailVC.contentName = title;
            NSLog(@"self.newsdata here %@",[[IonUtility sharedInstance] newsData]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:IonDetailVC animated:YES completion:nil];
            });
            
        }];
    }
    
    //end
    
}




#pragma mark - action


- (IBAction)settingBtnPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        IonSettingViewController *settingVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"settingVC"];
        [self presentViewController:settingVC animated:YES completion:nil];
    });
    
    
}

- (IBAction)profileBtnPressed:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        IonProfileViewController *IonProfileVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profileView"];
        [self presentViewController:IonProfileVC animated:YES completion:nil];
    });
    
}

- (IBAction)moveToContentView:(id)sender {
    [self.delegate moveToContentView];
}

-(void)LikeButtonPrssed{
    [[IonUtility sharedInstance] setIsLikeView:1];
    [[IonUtility sharedInstance] setIsFromProfileView:@"YES"];
    [self animateTableView:self.tableView];
    
    
}

-(void)StoryButtonPressed{
    [[IonUtility sharedInstance] setIsFromProfileView:@"NO"];
    [self animateTableView:self.tableView];
}

#pragma mark - notification center method

-(void)menuButtonPressed{
    
    [self animateTableView:self.tableView];
}

#pragma mark - methods

-(void)animateTableView:(UITableView *)tableView{
    [UIView transitionWithView:tableView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [tableView  reloadData];
                    } completion:NULL];
    
    
}


@end
