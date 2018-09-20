//
//  IonLoginViewViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 31/03/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonLoginViewViewController.h"
#import "Ionconstant.h"
#import "IonModelHeader.h"




@interface IonLoginViewViewController ()<UITextFieldDelegate, IonForgotPwdViewControllerDelegate>

@property (strong,nonatomic) IonForgotPwdViewController *modal;


@end

@implementation IonLoginViewViewController{
    CGFloat keyBoardSize;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.emailTextField designTextField];
    [self.passwordTextField designTextField];
    
    self.modal.view.tag = 99;
}


#pragma mark - tounch delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if(touch.view.tag!=99){
        [self dismissView];
    }
    
}

#pragma mark - textfield delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.passwordTextField) {
        self.passwordTextField.secureTextEntry = true;
    }else if (textField == self.emailTextField){
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    
}

#pragma mark - delegate for forgotPassword

-(void)nextButtonResponse{
    [self dismissView];
    [self.delegate animateAfterDismissKeyboard];
    
}


#pragma mark - methods

- (void)keyboardWillShow:(NSNotification *)notification {
    keyBoardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.delegate animateViewForKeyboard:keyBoardSize];
}

- (IBAction)checkLogin:(id)sender {
    NSString * errMsg = [self validationMethodOnLoginButtonClick];
    if (errMsg != nil) {
        [self resignResponse];
        [[IonUtility sharedInstance] alertView:errMsg viewController:self];
    }else{
        NSDictionary * paramDict = @{
                                     @"email" : self.emailTextField.text,
                                     @"password": self.passwordTextField.text,
                                     };
        
        [[requestHandler sharedInstance] logInresponseMethod:paramDict viewcontroller:self withHandler:^(id response) {
            
            
            IonUserInfo *userInfo = [IonUserInfo modelObjectWithDictionary:response];
            [[NSUserDefaults standardUserDefaults] setObject:[userInfo dictionaryRepresentation] forKey:@"user_detail"];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo.profileImg forKey:@"updateProfileImg"];
            [[NSUserDefaults standardUserDefaults] setValue:userInfo.token forKey:@"AUTH_KEY"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resignResponse];
                IonHomeViewController *IonHomeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IonHomeViewController"];
                [self presentViewController:IonHomeVC animated:YES completion:nil];
                
            });
            
            
        }];
        
    }
    
}


- (NSString *)validationMethodOnLoginButtonClick
{
    if (self.emailTextField.text.length == 0 && self.passwordTextField.text.length == 0) {
        return  @"Please enter your email ID and password";
    }
    
    else if(self.emailTextField.text.length > 0 && ![self.emailTextField.text isValidEmail]){
        return @"email ID is invalid";
    }
    
    else if (self.passwordTextField.text.length == 0)
    {
        return @"password cannot be empty";
    }
    
    else{
        return   nil;
    }
}

-(void)resignResponse{
    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


-(void)dismissView{
    if (self.childViewControllers.count != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.modal.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        } completion:^(BOOL finished) {
            [self.modal.view removeFromSuperview];
            [self.modal removeFromParentViewController];
            self.modal = nil;
            
        }];
        
    }
    
}



-(void)animateView{
    
    if (self.childViewControllers.count == 0) {
        self.modal = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"forgotVC"];
        [self addChildViewController:self.modal];
        //  self.modal.view.frame = CGRectMake(0, 568, 320, 284);
        self.modal.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.view addSubview:self.modal.view];
        [UIView animateWithDuration:0.5 animations:^{
            self.modal.view.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);;
        } completion:^(BOOL finished) {
            [self.modal didMoveToParentViewController:self];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.modal.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        } completion:^(BOOL finished) {
            [self.modal.view removeFromSuperview];
            [self.modal removeFromParentViewController];
            self.modal = nil;
        }];
    }
    
}

#pragma mark - action


- (IBAction)forgotPwdpressed:(id)sender {
    [self animateView];
    
}



@end
