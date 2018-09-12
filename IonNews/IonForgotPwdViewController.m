//
//  IonForgotPwdViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 11/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonForgotPwdViewController.h"
#import "Ionconstant.h"

@interface IonForgotPwdViewController ()<UITextFieldDelegate>

@end

@implementation IonForgotPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.forgotPwdMsg.hidden = YES;
    [self.emailTxtField designTextField];
    self.emailTxtField.keyboardType = UIKeyboardTypeEmailAddress;
    // Do any additional setup after loading the view.
}

#pragma mark - methods


- (NSString *)validationMethodOnLoginButtonClick
{
    if (self.emailTxtField.text.length == 0 ) {
        return  @"Please enter your email ID";
    }
    
    else if(self.emailTxtField.text.length > 0 && ![self.emailTxtField.text isValidEmail]){
        return @"email ID is invalid";
    }
    
    else{
        return   nil;
    }
}

#pragma mark - action


- (IBAction)nextBtnPressed:(id)sender {
    
    NSString * errMsg = [self validationMethodOnLoginButtonClick];
    if (errMsg != nil) {
        [self.emailTxtField resignFirstResponder];
        [[IonUtility sharedInstance] alertView:errMsg viewController:self];
    }else{
        
        NSDictionary * paramDict = @{
                                     @"email" : self.emailTxtField.text
                                     };
        
        [[requestHandler sharedInstance] forgotresponseMethod:paramDict viewcontroller:self withHandler:^(id response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.emailTxtField resignFirstResponder];
                [[IonUtility sharedInstance] alertView:[response objectForKey:@"message"] viewController:self];
                [self.delegate nextButtonResponse];
                self.emailTxtField.hidden = YES;
                self.forgotPwdMsg.hidden = NO;
                self.nextBtn.hidden = YES;
            });
            
        }];
        
    }
    
}


@end
