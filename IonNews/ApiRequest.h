//
//  ApiRequest.h
//  IonNews
//
//  Created by Himanshu Rajput on 18/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^apiHandler)(id data, NSError *serverError, NSURLResponse *headerresponse);

@interface ApiRequest : NSObject

+(ApiRequest *)sharedInstance;


-(void)postRequest: (NSString *)path param:(NSDictionary *)paramDict withHandler:(apiHandler)handler;
-(void)getRequest: (NSString *)path param:(NSDictionary *)paramDict withHandler:(apiHandler)handler;

@end
