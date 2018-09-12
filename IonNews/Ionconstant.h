//
//  Ionconstant.h
//  IonNews
//
//  Created by Himanshu Rajput on 19/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#ifndef Ionconstant_h
#define Ionconstant_h
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)

#import "ApiRequest.h"
#import "IonUtility.h"
#import "DBManager.h"
#import "Reachability.h"
#import "NSString+addition.h"
#import "UITextField+addition.h"
#import "IonHomeContentViewController.h"
#import "IonHomeProfileViewController.h"
#import "IonHomeProfileDetailCell.h"
#import "IonHomeProfileContentCell.h"
#import "IonHomeViewController.h"
#import "IonProfileHeaderView.h"
#import "IonHomeProfileCollectionCell.h"
#import "IonForgotPwdViewController.h"
#import "IonSignUpViewController.h"
#import "IonWelcomeViewController.h"
#import "IonLoginViewViewController.h"
#import "ion_imageUrlrequest.h"
#import "IonWebViewController.h"
#import "IonNewsDetailVC.h"
#import "IonNewsCollectionViewCell.h"
#import "IonNewsTitleCollectionViewCell.h"
#import "IonSettingViewController.h"
#import "IonProfileViewController.h"
#import "IonMenuViewController.h"
#import "requestHandler.h"
#import "IonAnimation.h"
#import "IonDismissalAnimation.h"
#import "menuTableViewCell.h"
#import "IonAnimatedDismissal.h"
#import "IonCustomActivityIndicator.h"




#endif /* Ionconstant_h */
