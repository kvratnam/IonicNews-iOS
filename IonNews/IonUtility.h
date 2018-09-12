//
//  IonUtility.h
//  IonNews
//
//  Created by Himanshu Rajput on 21/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IonUtility : NSObject

+(IonUtility * _Nullable)sharedInstance;
@property(nonatomic, strong) NSString* _Nullable isFromProfileView;
@property (nonatomic, assign) BOOL isLikeView;
@property (nonatomic, strong) NSArray * _Nullable newsData;
@property (nonatomic, assign) int pageNumber;

- (void)alertView:(NSString * _Nullable)alertStr viewController:(id _Nonnull)view;
@end
