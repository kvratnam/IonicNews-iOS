//
//  IonForgotPwdViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 11/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WaitSpinner.h>

@protocol IonForgotPwdViewControllerDelegate <NSObject>
-(void) nextButtonResponse;
@end

@interface IonForgotPwdViewController : UIViewController{
    WaitSpinner *waitSpinner;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (nonatomic, weak) id <IonForgotPwdViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *forgotPwdMsg;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end
