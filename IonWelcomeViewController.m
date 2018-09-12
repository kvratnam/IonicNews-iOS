//
//  IonWelcomeViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 31/03/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonWelcomeViewController.h"
#import "Ionconstant.h"



@interface IonWelcomeViewController ()<IonLoginViewViewControllerDelegate,IonSignUpViewControllerDelegate>

@property (strong,nonatomic) IonLoginViewViewController *modal;
@property (strong,nonatomic) IonSignUpViewController *signUpModal;

@end

@implementation IonWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modal.view.tag = 100;
    
}

#pragma mark - tounch delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if(touch.view.tag!=100){
        [self dismissView];
    }
    
}

#pragma mark - methods

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}


- (IBAction)logInPressed:(id)sender {
    [self animateViewForLogIn];
}
- (IBAction)signUpPressed:(id)sender {
    [self animateViewForSignUp];
}

-(void)animateViewForLogIn{
    if (self.childViewControllers.count == 0) {
        self.modal = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"logInView"];
        self.modal.delegate = self;
        [self addChildViewController:self.modal];
        //  self.modal.view.frame = CGRectMake(0, 568, 320, 284);
        self.modal.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
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

-(void)animateViewForSignUp{
    if (self.childViewControllers.count == 0) {
        self.signUpModal = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signUpView"];
        self.signUpModal.delegate = self;
        [self addChildViewController:self.signUpModal];
        //  self.modal.view.frame = CGRectMake(0, 568, 320, 284);
        self.signUpModal.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 500);
        [self.view addSubview:self.signUpModal.view];
        [UIView animateWithDuration:0.5 animations:^{
            self.signUpModal.view.frame = CGRectMake(0, self.view.frame.size.height - 500, self.view.frame.size.width, 500);;
        } completion:^(BOOL finished) {
            [self.signUpModal didMoveToParentViewController:self];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.signUpModal.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 500);
        } completion:^(BOOL finished) {
            [self.signUpModal.view removeFromSuperview];
            [self.signUpModal removeFromParentViewController];
            self.signUpModal = nil;
        }];
    }
    
}

-(void)dismissView{
    if (self.childViewControllers.count != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.modal.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
            self.signUpModal.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        } completion:^(BOOL finished) {
            [self.modal.view removeFromSuperview];
            [self.modal removeFromParentViewController];
            self.modal = nil;
            [self.signUpModal.view removeFromSuperview];
            [self.signUpModal removeFromParentViewController];
            self.signUpModal = nil;
        }];

    }

}

#pragma mark - delegate for loginView

-(void)animateViewForKeyboard:(CGFloat)keyBoardSize
{
 
    if (self.childViewControllers.count != 0) {
    [UIView animateWithDuration:0.5 animations:^{
        self.modal.view.frame = CGRectMake(0, (self.view.frame.size.height-300) - keyBoardSize, self.view.frame.size.width, 300);;
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


-(void)animateAfterDismissKeyboard{
    [self dismissView];
}

#pragma mark - delegate for signUpView

-(void)animateSignUpViewForKeyboard:(CGFloat)keyBoardSize{
    if (self.childViewControllers.count != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.signUpModal.view.frame = CGRectMake(0, (self.view.frame.size.height-300) - keyBoardSize, self.view.frame.size.width, 300);;
        } completion:^(BOOL finished) {
            [self.signUpModal didMoveToParentViewController:self];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.signUpModal.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        } completion:^(BOOL finished) {
            [self.signUpModal.view removeFromSuperview];
            [self.signUpModal removeFromParentViewController];
            self.signUpModal = nil;
        }];
    }


}




@end
