//
//  IonSearchContentViewController.m
//  IonNews
//
//  Created by Augustin on 27/09/18.
//  Copyright © 2018 Augustin. All rights reserved.
//

#import "IonSearchContentViewController.h"
#import "Ionconstant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IonSearchTableViewCell.h"

@interface IonHomeProfileViewController ()<UITableViewDelegate,UITableViewDataSource, IonHomeProfileContentCellDelegate, IonProfileHeaderViewDelegate,UISearchBarDelegate>

@end


@implementation IonSearchContentViewController{
    
    CGFloat scrollOffset;
    IonProfileHeaderView *view;
    IonHomeProfileDetailCell *detailCell;
    CGPoint lastContentOffset;
    Reachability *reachability;
    NetworkStatus internetStatus;
    NSMutableDictionary * user_detail;
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
    [self getSearchCategoryList];
//    [self getSearchTagLists];
    
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
            NSLog(@"Result for Story : %@",self.resultForStory);
            NSLog(@"Search Result Summary :%@",self.resultForStory.allKeys);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.titleForStory = [self.resultForStory allKeys].mutableCopy;
                titles = [self.resultForStory allKeys].mutableCopy;
                for (int i=0; i< titles.count ; i++) {
                    [ArrangeDict setValue:[titles objectAtIndex:i] forKey:[[[self.resultForStory valueForKey:[titles objectAtIndex:i]] objectAtIndex:0] valueForKey:@"id"]];
//                    NSArray *SortedKeys = [ArrangeDict keysSortedByValueUsingSelector:@selector(compare:)]; // Oct 26
                    
                    NSArray *sortedKeys = [[ArrangeDict allKeys] sortedArrayUsingSelector: @selector(compare:)];
                    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compare:)];
                    NSArray* sortedArray = [sortedKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
                    
//                    NSLog(@"Search  VC: %@",sortedArray);
                    [self.titleForStory removeAllObjects];
                    [self.searchTitleStory removeAllObjects];
                    for (NSString *key in sortedArray) // (NSString *key in sortedKeys)  Oct 23
                        [self.titleForStory addObject: [ArrangeDict objectForKey: key]];
                       self.searchTitleStory = [self.titleForStory mutableCopy];
                    
                }
                
                NSLog(@"Search title :%@",self.searchTitleStory);
                [self animateTableView:self.tableView];
                
            });
            
            /*{
                self.titleForStory = [self.resultForStory allKeys].mutableCopy;
                self.searchTitleStory = [self.resultForStory allKeys].mutableCopy;
                [self animateTableView:self.tableView];
                
                
            }*/
        }];
    }else{
        NSDictionary *sqliteData = [[DBManager getSharedInstance] ArrangeData];
        self.resultForStory = sqliteData;
        self.titleForStory = [self.resultForStory allKeys].mutableCopy;
        self.searchTitleStory = [self.resultForStory allKeys].mutableCopy;
        [self animateTableView:self.tableView];
        
    }
    
}

-(void)getSearchTagLists:(NSString *)givenSearchText {
    user_detail = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_detail"];
    if (internetStatus != NotReachable) {
        
//        [[requestHandler sharedInstance] getallLikeresponseMethod:nil viewcontroller:self withHandler:^(id response) {
//            self.result = [response objectForKey:@"data"];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //            [self.tableView reloadData];
//
//            });
//
//        }];
        
        
        NSDictionary * paramDict = @{
                                     @"tags" : givenSearchText,
                                     @"user_id" : [user_detail valueForKey:@"id"]
                                     };
        
        [[requestHandler sharedInstance] searchTagPostMethod:paramDict viewcontroller:self withHandler:^(id  _Nullable response) {
            self.resultForStory = response;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.resultForStory!= nil) {
                    self.resultForStory = [self.resultForStory valueForKeyPath:@"data.all_data"];
                    NSLog(@"Given Category Tag REsponse: %@",self.resultForStory);
                    if (self.resultForStory.count > 0) {
                        self.titleForStory = [self.resultForStory allKeys].mutableCopy;
                        self.searchTitleStory = [self.resultForStory allKeys].mutableCopy;
                        NSLog(@"SEarch Tag tittle for Story : %@ \n SearchTitleStory :%@",self.titleForStory,self.searchTitleStory);
                        [self animateTableView:self.tableView];
                        self.searchTable.hidden = YES;
                    }else{
                        [self.searchBar becomeFirstResponder];
                        [[IonUtility sharedInstance] alertView:@"No Result found for this selected Tag!" viewController:self];
                       
                        
                    }
                   
                
                }
                
            });
            
        }];
        
    }
    
}

-(void)searchCategoryList:(NSString *)givenCategoryText{
  
    self.searchTable.hidden  = YES;
    
    if (givenCategoryText> 0) {
        
        NSMutableArray * tempSearchDict = [[NSMutableArray alloc]init];
        
        for (NSString * searchDictObject in self.titleForStory) {
            
            if ([searchDictObject.lowercaseString containsString:givenCategoryText.lowercaseString]) {
                [tempSearchDict addObject:searchDictObject];
            }
        }
        
        NSLog(@"Search Dictionary :%@",tempSearchDict);
        
        self.searchTitleStory = [tempSearchDict mutableCopy];
        [self animateTableView:self.tableView];
        
    }else{
        
        self.searchTitleStory = self.titleForStory;
        [self animateTableView:self.tableView];
        
    }
}
    
-(void)getSearchCategoryList{
    
    if (internetStatus != NotReachable) {
        
        [[requestHandler sharedInstance] getSearchCategoryMethod:nil viewcontroller:self withHandler:^(id  _Nullable response) {
             self.resultCategoryList = response;
//            NSLog(@"Given Result for Search Category List  : %@",self.resultCategoryList);
//            self.resultCategory = [self.resultCategoryList mutableCopy];
            
            self.resultCategory = [self.resultCategoryList valueForKey:@"category"];
            self.searchResultCategory = [self.resultCategory mutableCopy];
            self.resultTag = [self.resultCategoryList valueForKey:@"tag"];
            self.searchResultTag = [self.resultTag mutableCopy];
            
//            NSLog(@"Given Result for Search Category List  : %@",[[self.resultCategory valueForKey:@"name"] objectAtIndex:0]);
            
             [self animateTableView:self.searchTable];
        }];
        
//        [[requestHandler sharedInstance] homePageStoryresponseMethod:nil viewcontroller:self withHandler:^(id  _Nullable response) {
//            self.resultForStory = response;
//            NSLog(@"Search Result Summary :%@",self.resultForStory.allKeys);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.titleForStory = [self.resultForStory allKeys].mutableCopy;
//                self.searchTitleStory = [self.resultForStory allKeys].mutableCopy;
//                [self animateTableView:self.tableView];
//
//
//            });
//        }];
    }else{
//        NSDictionary *sqliteData = [[DBManager getSharedInstance] ArrangeData];
//        self.resultForStory = sqliteData;
//        self.titleForStory = [self.resultForStory allKeys].mutableCopy;
//        self.searchTitleStory = [self.resultForStory allKeys].mutableCopy;
//        [self animateTableView:self.tableView];
        
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
                self.titleForStory = [self.resultForStory allKeys].mutableCopy;
                self.searchTitleStory = [self.resultForStory allKeys].mutableCopy;
                [self animateTableView:self.tableView];
                
                
            });
        }];
    }else{
        NSDictionary *sqliteData = [[DBManager getSharedInstance] ArrangeData];
        self.resultForStory = sqliteData;
        self.titleForStory = [self.resultForStory allKeys].mutableCopy;
        self.searchTitleStory = [self.resultForStory allKeys].mutableCopy;
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
    
    if (tableView == self.searchTable) {
    
        return 2;
  
    }else{
        
        return 1;
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (tableView == self.searchTable) {
        
        
//        return self.searchResultCategory.count;
        
        switch (section) {
            case 0:
                return self.searchResultCategory.count;
                break;
            case 1:
                return self.searchResultTag.count;
                break;
            default:
                return 0;
                break;
        }
    
    }else{
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
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchTable) {
        
        return 44.0;
       
        }else
        {
            CGFloat height;
            height = ceil((float) self.titleForStory.count/2)*(self.view.frame.size.width/2)+ceil((float) self.titleForStory.count/2)*10;
            return height;
            
          /*  switch (indexPath.section) {
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
            */
        }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   if (tableView == self.searchTable) {
       
       IonSearchTableViewCell *cell;
       
       cell = [tableView dequeueReusableCellWithIdentifier:@"IonSearchTableViewCell"];
       
//       cell.accessoryType = UITableViewCellAccessoryNone;
//
//       cell.accessoryView = nil;
       
       if (indexPath.section == 0) {
       
           cell.searchLabel.text = [[self.searchResultCategory valueForKey:@"name"] objectAtIndex:indexPath.row];
       
       }else{
           
           cell.searchLabel.text = [self.searchResultTag objectAtIndex:indexPath.row];
       }
       
       return cell;
       
  
   }else{
       
       IonHomeProfileContentCell *cell;
       cell = [tableView dequeueReusableCellWithIdentifier:@"IonHomeStoryCell"];
       cell.resultForStory = self.resultForStory;
       //            cell.titlesForStory = self.titleForStory;
       cell.titlesForStory = self.searchTitleStory;
       NSLog(@"Table Result Summary : %@ \n Tittle for Story : %@",self.resultForStory,self.titleForStory);
       /*
       if ([[IonUtility sharedInstance] isLikeView] == 1) {
           cell.result = self.result;
           
       }else{
           cell.resultForStory = self.resultForStory;
           //            cell.titlesForStory = self.titleForStory;
           cell.titlesForStory = self.searchTitleStory;
       }*/
       
       [cell.collectionView reloadData];
       cell.delegate = self;
       return cell;
       
       
       /*if (indexPath.section == 0) {
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
               //            cell.titlesForStory = self.titleForStory;
               cell.titlesForStory = self.searchTitleStory;
           }
           
           [cell.collectionView reloadData];
           cell.delegate = self;
           return cell;
       }*/
       
   }
    
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    view.delegate = self;
//
//    view.likesCountLbl.text = [NSString stringWithFormat:@"%lu",self.result.count];
//    view.storiesCountLbl.text = [NSString stringWithFormat:@"%lu",self.titleForStory.count];
//
//    if ([[IonUtility sharedInstance] isLikeView] == 1) {
//        view.likesCountLbl.textColor = [UIColor blackColor];
//        view.likesLbl.textColor = [UIColor blackColor];
//        view.storiesCountLbl.textColor = [UIColor lightGrayColor];
//        view.storiesLbl.textColor = [UIColor lightGrayColor];
//    }else{
//        view.likesCountLbl.textColor = [UIColor lightGrayColor];
//        view.likesLbl.textColor = [UIColor lightGrayColor];
//        view.storiesCountLbl.textColor = [UIColor blackColor];
//        view.storiesLbl.textColor = [UIColor blackColor];
//    }
//
//
//    return view;
//
//    /*if (section == 0) {
//        UIView *view2 = [[UIView alloc] init];
//        view2.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
//        view2.backgroundColor = [UIColor redColor];
//
//
//        return view2;
//
//    }else{
//
//        view.delegate = self;
//
//        view.likesCountLbl.text = [NSString stringWithFormat:@"%lu",self.result.count];
//        view.storiesCountLbl.text = [NSString stringWithFormat:@"%lu",self.titleForStory.count];
//
//        if ([[IonUtility sharedInstance] isLikeView] == 1) {
//            view.likesCountLbl.textColor = [UIColor blackColor];
//            view.likesLbl.textColor = [UIColor blackColor];
//            view.storiesCountLbl.textColor = [UIColor lightGrayColor];
//            view.storiesLbl.textColor = [UIColor lightGrayColor];
//        }else{
//            view.likesCountLbl.textColor = [UIColor lightGrayColor];
//            view.likesLbl.textColor = [UIColor lightGrayColor];
//            view.storiesCountLbl.textColor = [UIColor blackColor];
//            view.storiesLbl.textColor = [UIColor blackColor];
//        }
//
//
//        return view;
//
//    }*/
//
//
//}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView ==  self.searchTable) {
        return 20;
    }else{
        return 0;
    }
    
//    switch (section) {
//        case 0:
//            return 0;
//            break;
//
//        case 1:
//            return 55;
//            break;
//
//        default:
//            return 0;
//            break;
//    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView ==  self.searchTable) {
       
        switch (section) {
            case 0:
                return @"Category";
                break;
                
            case 1:
                return @"Tags";
                break;
                
            default:
                return @"";
                break;
        }

    }else{
        return @"";
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView ==  self.searchTable) {
        [self.searchBar resignFirstResponder];
        if (indexPath.section == 0) {
            NSLog(@"SElected Index : %@",[[self.searchResultCategory objectAtIndex:indexPath.row] valueForKey:@"name"]);
            [self searchCategoryList:[[self.searchResultCategory objectAtIndex:indexPath.row] valueForKey:@"name"]];
        }else if (indexPath.section == 1) {
            
            NSLog(@"SElected Index : %@",[self.searchResultTag objectAtIndex:indexPath.row]);
            [self getSearchTagLists:[self.searchResultTag objectAtIndex:indexPath.row]];
        }
    }
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
     [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
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

#pragma mark -Search Functionlity

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText{
    
    self.searchTable.hidden = NO;
   
    NSLog(@"Search Text : %@",searchText);
    
    if (searchText.length > 0) {
        
        NSMutableArray * tempSearchDict = [[NSMutableArray alloc]init];
        NSMutableArray * tempSearchDictTag = [[NSMutableArray alloc]init];
        
        for (NSArray * searchDictObject in self.resultCategory) {
            
            if ([[[searchDictObject valueForKey:@"name"] lowercaseString] containsString:searchText.lowercaseString]) {
                [tempSearchDict addObject:searchDictObject];
            }
        }
        
        for (NSString * searchDictObject in self.resultTag) {
            
            if ([[searchDictObject lowercaseString] containsString:searchText.lowercaseString]) {
                [tempSearchDictTag addObject:searchDictObject];
            }
        }
        
        
        
        NSLog(@"Search Dictionary :%@",tempSearchDict);
        
        self.searchResultCategory = [tempSearchDict mutableCopy];
        self.searchResultTag = [tempSearchDictTag mutableCopy];
        [self animateTableView:self.searchTable];
        
    }else{
        
        self.searchResultCategory = [self.resultCategory mutableCopy];
        self.searchResultTag = [self.resultTag mutableCopy];
        [self animateTableView:self.searchTable];
        
    }/*
   
    self.searchTable.hidden  = YES;
   
    if (searchText.length > 0) {
    
        NSMutableArray * tempSearchDict = [[NSMutableArray alloc]init];
        
        for (NSString * searchDictObject in self.titleForStory) {
            
            if ([searchDictObject.lowercaseString containsString:searchText.lowercaseString]) {
                [tempSearchDict addObject:searchDictObject];
            }
        }
        
        NSLog(@"Search Dictionary :%@",tempSearchDict);
        
        self.searchTitleStory = [tempSearchDict mutableCopy];
        [self animateTableView:self.tableView];
   
    }else{
      
        self.searchTitleStory = self.titleForStory;
        [self animateTableView:self.tableView];
    
    }*/

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

- (IBAction)searchCancelAction:(id)sender {
    [self.searchBar resignFirstResponder];
    self.searchTable.hidden = YES;
    self.searchTitleStory = self.titleForStory;
    [self animateTableView:self.tableView];
    self.searchBar.text = @"";
    
    self.searchResultCategory = [self.resultCategory mutableCopy];
    self.searchResultTag = [self.resultTag mutableCopy];
    [self animateTableView:self.searchTable];
    
    
}


@end
