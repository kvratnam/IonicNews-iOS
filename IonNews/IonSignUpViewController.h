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
@property (nonatomic, weak) id <IonSignUpViewControllerDelegate> delegate;
@property(nonatomic,strong) UIActivityIndicatorView * activityIndicator;
//@property (nonatomic, strong) UIPickerView *rolepicker;


@end
