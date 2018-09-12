//
//  IonSettingViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 11/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonSettingViewController.h"
#import "Ionconstant.h"

@interface IonSettingViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation IonSettingViewController
{
    NSArray *title;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    title  = @[@"About",@"Help & Feedback",@"Logout"];
    
    // Do any additional setup after loading the view.
}

-(BOOL)prefersStatusBarHidden{

    return YES;
}


#pragma mark - tableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat size;
    if (indexPath.row == 0) {
        size = 80;
    }else{
        size = 60;
    }

    return size;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = title[indexPath.row];
    if (indexPath.row == 0) {
      cell.detailTextLabel.text = @"App Version 1.0";
    }else{
    cell.detailTextLabel.text = @"";
    }
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.5;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    if (indexPath.row == 0) {
        border.frame = CGRectMake(0, 80 - borderWidth, cell.frame.size.width, cell.frame.size.height);
    }else{
    border.frame = CGRectMake(0, 60 - borderWidth, cell.frame.size.width, cell.frame.size.height);
    }
    
    border.borderWidth = borderWidth;
    [cell.layer addSublayer:border];
    cell.layer.masksToBounds = YES;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AUTH_KEY"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"updateProfileImg"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceToken"];
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        IonWelcomeViewController *add =
        [storyboard instantiateViewControllerWithIdentifier:@"welcome"];
        
        [self presentViewController:add
                           animated:YES
                         completion:nil];
    }

}

#pragma mark - action
- (IBAction)doneBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
