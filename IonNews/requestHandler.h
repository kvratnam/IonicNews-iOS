//
//  requestHandler.h
//  IonNews
//
//  Created by Himanshu Rajput on 19/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^responseHandler )(id _Nullable response);

@interface requestHandler : NSObject

+(requestHandler * _Nonnull)sharedInstance;

-(void)logInresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler;
-(void)signUpresponseMethod: (NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler;
-(void)forgotresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler;
-(void)homePageStoryresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler;
-(void)updateProfileresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler;
-(void)updateImageresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler;
-(void)storyListresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view category:(int)category page:(int)page withHandler:(responseHandler _Nullable)handler;
-(void)storyLikeresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nullable)view withHandler:(responseHandler _Nullable)handler;
-(void)getallLikeresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler;
-(void)getuserGroupresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler;

@end
