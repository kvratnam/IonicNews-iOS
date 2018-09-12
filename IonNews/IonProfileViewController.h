//
//  IonProfileViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 10/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IonProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *orgTxtField;
@property (weak, nonatomic) IBOutlet UITextField *desgTxtField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *role;
@property (nonatomic, strong) UIPickerView *rolepicker;

@end
