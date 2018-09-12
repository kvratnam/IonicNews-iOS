//
//  NSString+addition.m
//  IonNews
//
//  Created by Himanshu Rajput on 03/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "NSString+addition.h"

@implementation NSString (addition)


- (BOOL)isValidEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailPredicate evaluateWithObject:self];
}

- (BOOL)isValidName {
    return (self.length >= 3);
}

- (BOOL)isValidPassword {
    return (self.length >= 6);
}

- (BOOL) isValidMobileNumber{
    NSString *regex = @"^[0-9]{10}$";
    NSPredicate *mobileNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileNumberPredicate evaluateWithObject:self];
    
}

@end
