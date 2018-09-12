//
//  IonSignUpViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 03/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonSignUpViewController.h"
#import "Ionconstant.h"

@interface IonSignUpViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

@end

@implementation IonSignUpViewController{
CGFloat keyBoardSize;
    NSString *role_id;
// NSArray *pickerArray;
}

- (void)viewDidLoad {
//    pickerArray  =[[NSArray alloc] init];
//    
//    [[requestHandler sharedInstance]getuserGroupresponseMethod:nil viewcontroller:self withHandler:^(id  _Nullable response) {
//        pickerArray = response;
//    }];
    
    [super viewDidLoad];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [self.FirstNameTxtField designTextField];
    [self.LastNameTxtField designTextField];
    [self.PhoneTxtField designTextField];
    [self.EmailTxtField designTextField];
    [self.PasswordTxtField designTextField];
    [self.orgTxtField designTextField];
    [self.designTxtField designTextField];
    
//    self.rolepicker = [[UIPickerView alloc] init];
//    self.rolepicker.delegate = self;
//    self.rolepicker.dataSource = self;
//    self.rolepicker.showsSelectionIndicator = YES;
 //   self.roleTxtField.inputView = self.rolepicker;
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
//                                   target:self action:@selector(done:)];
//    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
//                          CGRectMake(0, self.view.frame.size.height-
//                                     self.rolepicker.frame.size.height-50, self.view.frame.size.width, 50)];
//    [toolBar setBarStyle:UIBarStyleBlackOpaque];
//    NSArray *toolbarItems = [NSArray arrayWithObjects: 
//                             doneButton, nil];
//    [toolBar setItems:toolbarItems];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.PasswordTxtField) {
        self.PasswordTxtField.secureTextEntry = true;
    }else if (textField == self.EmailTxtField){
        self.EmailTxtField.keyboardType = UIKeyboardTypeEmailAddress;
    }else if (textField == self.PhoneTxtField){
        self.PhoneTxtField.keyboardType = UIKeyboardTypePhonePad;
    }else if (textField ==self.designTxtField){
    
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==self.PhoneTxtField)
    {
        
        //limits the mobile number text field to 10 digits only
        NSUInteger newLength = [self.PhoneTxtField.text length] + [string length] - range.length;
        return (newLength > 10) ? NO : YES;
    }
    return YES;
}



#pragma mark - Picker View Data source
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 1;
//}
//-(NSInteger)pickerView:(UIPickerView *)pickerView
//numberOfRowsInComponent:(NSInteger)component{
//    return [pickerArray count];
//}
//
//#pragma mark- Picker View Delegate
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
//(NSInteger)row inComponent:(NSInteger)component{
//    [self.roleTxtField setText:[[pickerArray objectAtIndex:row] valueForKey:@"slug"]];
//    role_id = [[pickerArray objectAtIndex:row] valueForKey:@"id"];
//}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
//(NSInteger)row forComponent:(NSInteger)component{
//    return [[pickerArray objectAtIndex:row] valueForKey:@"slug"];
//}

#pragma mark - methods


- (void)keyboardWillShow:(NSNotification *)notification {
    keyBoardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.delegate animateSignUpViewForKeyboard:keyBoardSize];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;

}

- (IBAction)checkSignUp:(id)sender {
    NSString * errMsg = [self validationMethodOnLoginButtonClick];
    if (errMsg != nil) {
        [self resignKeyboard];
        [[IonUtility sharedInstance] alertView:errMsg viewController:self];
    }else{
        
       NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        NSString *device_code;
        if (token) {
            device_code = token;
        }else{
        device_code = @"abc";
        }
      
        NSDictionary * paramDict =  @{
            @"email" : self.EmailTxtField.text,
            @"first_name": self.FirstNameTxtField.text,
            @"last_name": self.LastNameTxtField.text,
            @"password": self.PasswordTxtField.text,
            @"phone": self.PhoneTxtField.text,
            @"company": self.orgTxtField.text,
            @"designation": self.designTxtField.text,
             @"role": @"user",
            @"role_id": @"2",
            @"device_code" : [NSString stringWithFormat:@"%@",device_code],
            @"device_type" : @"iphone"
        };
        
//       NSDictionary * paramDict = @{
//            @"email" : @"",
//            @"first_name":@"Himanshu",
//            @"last_name": @"Rajput",
//            @"password": @"password",
//            @"phone":@"9886663635",
//            @"role":@"user",
//            @"company": @"mantra",
//            @"designation" : @"ios developer"
//            };
        [[requestHandler sharedInstance] signUpresponseMethod:paramDict viewcontroller:self withHandler:^(id response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resignKeyboard];
                [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"user_detail"];
                [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"token"] forKey:@"AUTH_KEY"];
                IonHomeViewController *IonHomeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IonHomeViewController"];
                [self presentViewController:IonHomeVC animated:YES completion:nil];
            });
        }];
    
     }
}


- (NSString *)validationMethodOnLoginButtonClick
{
    if (self.EmailTxtField.text.length == 0 && self.PasswordTxtField.text.length == 0 && self.FirstNameTxtField.text.length == 0 && self.LastNameTxtField.text.length == 0 && self.PhoneTxtField.text.length == 0) {
        return  @"Please enter all field";
    }
    else if (self.FirstNameTxtField.text.length == 0)
    {
        return @"First Name cannot be empty";
    }
    else if(self.FirstNameTxtField.text.length > 0 && ![self.FirstNameTxtField.text isValidName]){
        return @"First Name is invalid";
    }
    else if (self.LastNameTxtField.text.length == 0)
    {
        return @"Last Name cannot be empty";
    }
    else if(self.LastNameTxtField.text.length > 0 && ![self.LastNameTxtField.text isValidName]){
        return @"Last Name is invalid";
    }
//    else if (self.PhoneTxtField.text.length == 0)
//    {
//        return @"Phone Number cannot be empty";
//    }
    else if(self.PhoneTxtField.text.length > 0 && ![self.PhoneTxtField.text isValidMobileNumber]){
        return @"Phone Number is invalid";
    }
    
    else if(self.EmailTxtField.text.length > 0 && ![self.EmailTxtField.text isValidEmail]){
        return @"email ID is invalid";
    }
    
    else if (self.PasswordTxtField.text.length == 0)
    {
        return @"password cannot be empty";
    }
    else if(self.PasswordTxtField.text.length > 0 && ![self.PasswordTxtField.text isValidPassword]){
        return @"password is invalid";
    }
    else{
        return   nil;
    }
}

-(void)done:(id)sender{
    [sender resignFirstResponder];

}

-(void)resignKeyboard{
    [self.FirstNameTxtField resignFirstResponder];
    [self.LastNameTxtField resignFirstResponder];
    [self.EmailTxtField resignFirstResponder];
    [self.PhoneTxtField resignFirstResponder];
    [self.PasswordTxtField resignFirstResponder];
    [self.designTxtField resignFirstResponder];

}

@end
