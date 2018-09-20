//
//  requestHandler.m
//  IonNews
//
//  Created by Himanshu Rajput on 19/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "requestHandler.h"
#import "Ionconstant.h"



NSString *const KIonLoginUrl = @"authentication/login";
NSString *const KIonSignupUrl = @"authentication/register";
NSString *const KForgotUrl = @"authentication/forgot";
NSString *const KStoryUrl = @"story/homepage";
NSString *const KUpdateImgUrl = @"authentication/updateProfileImg";
NSString *const KUpdateProfileUrl = @"authentication/update";
NSString *const KStoryListUrl = @"story/list?category_id=";
NSString *const KGetAllStoryLikeUrl = @"story/getAllLikeStory";
NSString *const KStoryLikeUrl = @"story/story_like";
NSString *const KuserGroupsUrl = @"category/user_group";

@implementation requestHandler

+(requestHandler * _Nonnull)sharedInstance{
    static requestHandler *this = nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        this = [[self alloc]init];
    });
    return this;
}


-(id)errorHandler: (NSData *)data serverError:(NSError *)error headerResponse:(NSURLResponse *)response viewController:(id)view{
    NSDictionary *json;
    NSString *message;
    if (data != nil) {
         NSHTTPURLResponse * header = (NSHTTPURLResponse*)response;
        
        
        switch (header.statusCode) {
            case 200:
                
               json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                return json;
                break;
            case 400:
                
                json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                message = [json objectForKey:@"message"];
                [self alertViewMethod:message viewController:view];
                break;
                
            case 401:
                
                json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                message = [json objectForKey:@"message"];
                [self alertViewMethod:message viewController:view];
                break;
                
            default:
                
                [self alertViewMethod:@"You seem to be offline.\nCheck your network settings." viewController:view];
                break;
        }
        
    }else{
        [self alertViewMethod:@"You seem to be offline.\nCheck your network settings." viewController:view];
    }
    return nil;
}

-(void)logInresponseMethod:(NSDictionary *)param viewcontroller:(id)view withHandler:(responseHandler)handler{
    
    [[ApiRequest sharedInstance] postRequest:KIonLoginUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
    }];
    
}

-(void)signUpresponseMethod:(NSDictionary *)param viewcontroller:(id)view withHandler:(responseHandler)handler{
    [[ApiRequest sharedInstance] postRequest:KIonSignupUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
    
    }];

}


-(void)forgotresponseMethod:(NSDictionary *)param viewcontroller:(id)view withHandler:(responseHandler)handler{
    [[ApiRequest sharedInstance] postRequest:KForgotUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
        
    }];

}

-(void)homePageStoryresponseMethod:(NSDictionary *)param viewcontroller:(id)view withHandler:(responseHandler)handler{
    [[ApiRequest sharedInstance] getRequest:KStoryUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
        
    }];
}

-(void)updateProfileresponseMethod:(NSDictionary *)param viewcontroller:(id)view withHandler:(responseHandler)handler{
    [[ApiRequest sharedInstance] postRequest:KUpdateProfileUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }
    }];
    
}

-(void)updateImageresponseMethod:(NSDictionary *)param viewcontroller:(id)view withHandler:(responseHandler)handler{
    [[ApiRequest sharedInstance] postRequest:KUpdateImgUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
        
    }];
    
}

-(void)storyListresponseMethod:(NSDictionary *)param viewcontroller:(id)view category:(int)category page:(int)page withHandler:(responseHandler)handler{
    [[ApiRequest sharedInstance] getRequest:[NSString stringWithFormat:@"%@%d&page=%d",KStoryListUrl,category,page] param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
        
    }];

}

-(void)storyLikeresponseMethod:(NSDictionary *)param viewcontroller:(id)view withHandler:(responseHandler)handler{
    [[ApiRequest sharedInstance] postRequest:KStoryLikeUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
        
    }];
    
}

-(void)getallLikeresponseMethod:(NSDictionary *)param viewcontroller:(id)view withHandler:(responseHandler)handler{

    [[ApiRequest sharedInstance] getRequest:KGetAllStoryLikeUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
        
    }];

}


-(void)getuserGroupresponseMethod:(NSDictionary * _Nullable)param viewcontroller:(id _Nonnull)view withHandler:(responseHandler _Nullable)handler{

    [[ApiRequest sharedInstance] getRequest:KuserGroupsUrl param:param withHandler:^(id data, NSError *serverError, NSURLResponse *headerresponse) {
        
        id response = [self errorHandler:data serverError:serverError headerResponse:headerresponse viewController:view];
        if (response != nil) {
            handler(response);
        }else{
            handler(nil);
        }
        
    }];

}


- (void)alertViewMethod:(NSString * )alertStr viewController:(id)view
{
    
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
