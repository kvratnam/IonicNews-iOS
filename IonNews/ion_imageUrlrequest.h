//
//  ion_imageUrlrequest.h
//  IonNews
//
//  Created by Himanshu Rajput on 12/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^imgUrlHandler)(id _Nullable image, NSError * _Nullable error);

@interface ion_imageUrlrequest : NSObject

+(ion_imageUrlrequest * _Nullable)shared;

- (void)setImageWithUrl:(NSURL * _Nullable )imageUrl withHandler:(_Nonnull imgUrlHandler )handler ;

@end
