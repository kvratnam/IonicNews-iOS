//
//  IonUserInfo.m
//  IonNews
//
//  Created by Himanshu Rajput on 19/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonUserInfo.h"

@implementation IonUserInfo


+(instancetype)modelObjectWithDictionary: (NSDictionary *)dict{


    return [[self alloc] initWithDictionary:dict];
}


-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
   
    //this will check server is returning dictionary or not
    //other wise pass into model
    //it will not break parsing
    
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.email = [self objectOrNilForKey:@"email" fromDictionary:dict];
        self.first_name = [self objectOrNilForKey:@"first_name" fromDictionary:dict];
        self.last_name = [self objectOrNilForKey:@"last_name" fromDictionary:dict];
        self.phone = [self objectOrNilForKey:@"phone" fromDictionary:dict];
        self.company = [self objectOrNilForKey:@"company" fromDictionary:dict];
        self.designation = [self objectOrNilForKey:@"designation" fromDictionary:dict];
        self.role = [self objectOrNilForKey:@"role" fromDictionary:dict];
        self.role_id = [self objectOrNilForKey:@"role_id" fromDictionary:dict];
        self.profileImg = [self objectOrNilForKey:@"profileImg" fromDictionary:dict];
        self.user_id = [self objectOrNilForKey:@"id" fromDictionary:dict];
        self.token = [self objectOrNilForKey:@"token" fromDictionary:dict];
        
    }
    
    return self;

}

#pragma mark - dataParsing check method

-(NSDictionary *)dictionaryRepresentation{
    NSMutableDictionary *mutabledict = [NSMutableDictionary dictionary];
    [mutabledict setValue:self.email forKey:@"email"];
    [mutabledict setValue:self.first_name forKey:@"first_name"];
    [mutabledict setValue:self.last_name forKey:@"last_name"];
    [mutabledict setValue:self.phone forKey:@"phone"];
    [mutabledict setValue:self.company forKey:@"company"];
    [mutabledict setValue:self.designation forKey:@"designation"];
    [mutabledict setValue:self.role forKey:@"role"];
    [mutabledict setValue:self.role_id forKey:@"role_id"];
    [mutabledict setValue:self.profileImg forKey:@"profileImg"];
    [mutabledict setValue:self.user_id forKey:@"id"];
    [mutabledict setValue:self.token forKey:@"token"];
    
    return [NSDictionary dictionaryWithDictionary:mutabledict];

}

-(NSString *)description{

    return [NSString stringWithFormat:@"%@",[self dictionaryRepresentation]];
}

#pragma mark - Helper Method

-(id)objectOrNilForKey:(id)key fromDictionary:(NSDictionary *)dict{

    id object = [dict objectForKey:key];
    return [object isEqual:[NSNull null]] ? nil : object;

}

#pragma mark - NSCoding Methods

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.first_name = [aDecoder decodeObjectForKey:@"first_name"];
    self.last_name = [aDecoder decodeObjectForKey:@"last_name"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
    self.company = [aDecoder decodeObjectForKey:@"company"];
    self.designation = [aDecoder decodeObjectForKey:@"designation"];
    self.role = [aDecoder decodeObjectForKey:@"role"];
    self.role_id = [aDecoder decodeObjectForKey:@"role_id"];
    self.profileImg = [aDecoder decodeObjectForKey:@"profileImg"];
    self.user_id = [aDecoder decodeObjectForKey:@"id"];
    self.token = [aDecoder decodeObjectForKey:@"token"];
    
    return self;

}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.first_name forKey:@"first_name"];
    [aCoder encodeObject:self.last_name forKey:@"last_name"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.company forKey:@"company"];
    [aCoder encodeObject:self.designation forKey:@"designation"];
    [aCoder encodeObject:self.role forKey:@"role"];
    [aCoder encodeObject:self.role_id forKey:@"role_id"];
    [aCoder encodeObject:self.profileImg forKey:@"profileImg"];
    [aCoder encodeObject:self.user_id forKey:@"id"];
    [aCoder encodeObject:self.token forKey:@"token"];
   

}

-(id)copyWithZone:(NSZone *)zone{
    IonUserInfo *copy = [[IonUserInfo alloc] init];
    if (copy) {
        copy.email = [self copyWithZone:zone];
        copy.first_name = [self copyWithZone:zone];
        copy.last_name = [self copyWithZone:zone];
        copy.phone = [self copyWithZone:zone];
        copy.company = [self copyWithZone:zone];
        copy.designation = [self copyWithZone:zone];
        copy.role = [self copyWithZone:zone];
        copy.role_id = [self copyWithZone:zone];
        copy.profileImg = [self copyWithZone:zone];
        copy.user_id = [self copyWithZone:zone];
        copy.token = [self copyWithZone:zone];
        
    }
    
    return copy;

}



@end
