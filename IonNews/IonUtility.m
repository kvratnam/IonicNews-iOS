//
//  IonUtility.m
//  IonNews
//
//  Created by Himanshu Rajput on 21/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonUtility.h"
#import "Ionconstant.h"

@implementation IonUtility

+(IonUtility *)sharedInstance{
    static  IonUtility *this = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        this = [[self alloc] init];
    });
    return this;
    
}

- (void)alertView:(NSString * _Nullable)alertStr viewController:(id _Nonnull)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertStr message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * yesButtonAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:yesButtonAction];
        [view presentViewController:alert animated:YES completion:nil];
    });
}



@end
