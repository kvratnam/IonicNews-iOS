//
//  ion_imageUrlrequest.m
//  IonNews
//
//  Created by Himanshu Rajput on 12/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "ion_imageUrlrequest.h"
#import <UIKit/UIKit.h>

@implementation ion_imageUrlrequest

+(ion_imageUrlrequest * _Nullable)shared {
    static ion_imageUrlrequest * this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc]init];
    });
    return this;
}

- (void)setImageWithUrl:(NSURL * _Nullable )imageUrl withHandler:(_Nonnull imgUrlHandler )handler {
    
    [self manageMemory];
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *  task  = [session dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            handler(nil,error);
        }
        else if(data == nil){
            handler(nil,nil);
        }
        else{
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIImage * image = [UIImage imageWithData:data];
                 handler(image,nil);
             });
            
        }
    }];
    [task resume];
}

- (void)manageMemory {
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:500 * 1024 * 1024
                                                         diskCapacity:500 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

@end
