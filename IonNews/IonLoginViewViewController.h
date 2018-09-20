//
//  IonLoginViewViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 31/03/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IonLoginViewViewControllerDelegate <NSObject>
- (void) animateViewForKeyboard: (CGFloat )keyBoardSize;
-(void) animateAfterDismissKeyboard;
@end

@interface IonLoginViewViewController : UIViewController

@property (nonatomic, weak) id <IonLoginViewViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
