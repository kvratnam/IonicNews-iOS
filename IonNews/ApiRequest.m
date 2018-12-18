//
//  ApiRequest.m
//  IonNews
//
//  Created by Himanshu Rajput on 18/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "ApiRequest.h"
#import "Ionconstant.h"

static NSString *domainUrl = @"https://www.anionnews.com/api/";  //production url
//static NSString *domainUrl = @"http://dev.anionnews.com/api/"; // New Dev URL

//static NSString *domainUrl = @"http://34.212.156.81/api/";  //Old production url
//static NSString *domainUrl = @"http://50.112.57.146/api/"; // Old Dev URL

@implementation ApiRequest

+(ApiRequest *)sharedInstance{

    static ApiRequest *this = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        this = [[self alloc] init];
    });
    return this;
}

-(NSMutableURLRequest *)createRequest:(NSString *)path method:(NSString *)method param:(NSDictionary *)paramDict{
    NSError * error = nil;
    NSURL *url = [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:domainUrl]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    request.HTTPMethod = method;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *auth_key = [[NSUserDefaults standardUserDefaults] objectForKey:@"AUTH_KEY"];
    
    if (auth_key != nil) {
        [request setValue:auth_key forHTTPHeaderField:@"Authorization"];
    }else{
        [request setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    
    if (![method isEqualToString:@"GET"] && paramDict != nil) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:&error];
    }

    return request;
}

-(void) getRequest:(NSString *)path param:(NSDictionary *)paramDict withHandler:(apiHandler)handler{

    NSURLRequest *request = [self createRequest:path method:@"GET" param:paramDict];
    NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        if (internetStatus != NotReachable) {
            handler(data, error, response);
        }else{
            handler(nil,[NSError errorWithDomain:@"IonNews" code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Network not found" }],nil);
        }
        
        
    }];
    [task resume];


}

-(void)postRequest:(NSString *)path param:(NSDictionary *)paramDict withHandler:(apiHandler)handler{
    NSURLRequest * request = [self createRequest:path method:@"POST" param:paramDict];
    NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        if (internetStatus != NotReachable) {
            handler(data, error, response);
        }else{
            handler(nil,[NSError errorWithDomain:@"IonNews" code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Network not found" }],nil);
        }
        
    }];
    [task resume];
    
}



@end
