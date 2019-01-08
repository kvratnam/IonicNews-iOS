//
//  IonLoginViewViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 31/03/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WaitSpinner.h>



@protocol IonLoginViewViewControllerDelegate <NSObject>
- (void) animateViewForKeyboard: (CGFloat )keyBoardSize;
-(void) animateAfterDismissKeyboard;
@end

@interface IonLoginViewViewController : UIViewController{
        WaitSpinner *waitSpinner;
}

@property (nonatomic, weak) id <IonLoginViewViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNamePlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *passwordPlaceHolder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
