//
//  IonUserInfo.h
//  IonNews
//
//  Created by Himanshu Rajput on 19/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IonUserInfo : NSObject<NSCoding, NSCopying>

@property(strong, nonatomic)NSString *email;
@property(strong, nonatomic)NSString *first_name;
@property(strong, nonatomic)NSString *last_name;
@property(strong, nonatomic)NSString *password;
@property(strong, nonatomic)NSString *phone;
@property(strong, nonatomic)NSString *company;
@property(strong, nonatomic)NSString *designation;
@property(strong, nonatomic)NSString *role;
@property(strong, nonatomic)NSString *role_id;
@property(strong, nonatomic)NSString *profileImg;
@property(strong, nonatomic)NSString *token;


+(instancetype)modelObjectWithDictionary: (NSDictionary *)dict;
-(instancetype)initWithDictionary: (NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;
-(id)objectOrNilForKey: (id)key fromDictionary: (NSDictionary *)dict;

@end
