//
//  IonSignUpViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 03/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WaitSpinner.h>


@protocol IonSignUpViewControllerDelegate <NSObject>

-(void) animateSignUpViewForKeyboard: (CGFloat )keyBoardSize;

@end

@interface IonSignUpViewController : UIViewController{
    WaitSpinner *waitSpinner;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *FirstNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *LastNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *EmailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *PhoneTxtField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *orgTxtField;
@property (weak, nonatomic) IBOutlet UITextField *designTxtField;
@property (weak, nonatomic) IBOutlet UITextField *rollTxtField;
@property (nonatomic, weak) id <IonSignUpViewControllerDelegate> delegate;
@property(nonatomic,strong) UIActivityIndicatorView * activityIndicator;
//@property (nonatomic, strong) UIPickerView *rolepicker;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstNamePlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *lastNamePlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *phonePlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *emailPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *passwordPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *orgPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *designationPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *rollPlaceHolder;
@property (nonatomic, strong) UIPickerView *rolepicker;


@end
