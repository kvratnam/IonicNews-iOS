//
//  IonMenuViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 11/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonMenuViewController.h"
#import "Ionconstant.h"

@interface IonMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation IonMenuViewController
{

    NSArray *title;
    NSArray *images;
    IonWebViewController *IonwebVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    title = @[@"Like",@"Share",@"Open in Safari"];
    images = @[@"like_white",@"share",@"safari"];
        IonwebVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webView"];
    
    // Do any additional setup after loading the view.
}

#pragma mark - tableview delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    menuTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"menuTableViewCell"];
    cell.titleLbl.text = [title objectAtIndex:indexPath.row];
    cell.titleLbl.font = [UIFont fontWithName:@"SourceSerifPro-Regular" size:14];
    cell.image.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
   
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            NSDictionary * paramDict = @{
                                         @"content_id" : self.content_id,
                                         };
            [[requestHandler sharedInstance] storyLikeresponseMethod:paramDict viewcontroller:self withHandler:^(id  _Nullable response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (response!= nil) {
                        [self.delegate likeButtonPressed];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                });
                
            }];
            
        }
            break;
        case 1:
            {
                NSLog(@"share button pressed");

                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *texttoshare = @"check out this story: ";
                    NSURL *url = [NSURL URLWithString:self.crawl_url];
                    NSString *appname = @"ION News!";
                    //    UIImage *imagetoshare = [UIImage imageNamed:@"notification"]; //this is your image to share
                    NSArray *activityItems = @[texttoshare, url, appname];
                    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
                    [self presentViewController:activityVC animated:TRUE completion:nil];
                });
                
        
            }
            break;
        case 2:
            IonwebVC.crawl_url = self.crawl_url;
            IonwebVC.content_id = self.content_id;
            [self presentViewController:IonwebVC animated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
}


#pragma mark - action
- (IBAction)closeBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
