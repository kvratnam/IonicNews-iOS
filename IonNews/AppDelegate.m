//
//  AppDelegate.m
//  IonNews
//
//  Created by Himanshu Rajput on 31/03/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "AppDelegate.h"
#import "Ionconstant.h"
#import <Crashlytics/Crashlytics.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@import Firebase;
@import Fabric;


@interface AppDelegate ()
{

    Reachability *reachability;
    NetworkStatus internetStatus;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    [Fabric with:@[[Crashlytics class]]];
    [Fabric.sharedSDK setDebug:YES];
    [self registerForRemoteNotifications];
//    [[Crashlytics sharedInstance] crash];

    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // If application is launched due to  notification,present another view controller.
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
         IonWebViewController *IonwebVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webView"];
        [self.window.rootViewController presentViewController:IonwebVC animated:YES completion:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    // [self updateInterfaceWithReachability:self.internetReachability];
    [self checkIfInternetExists];
    
    NSLog(@"Authenticatio key : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AUTH_KEY"]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"AUTH_KEY"] != nil) {
        // Show the dashboard
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"IonHomeViewController"];
    } else {
        // Login
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"logInView"];
        //[storyboard instantiateViewControllerWithIdentifier:@"welcome"];//
    }
    [self.window makeKeyAndVisible];
    
    

    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    
    
    
    if ([shortcutItem.type isEqualToString:@"com.IonNews.app.Profile"]) {
//        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profileView"];
                                IonProfileViewController *IonProfileVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profileView"];
        [self.window.rootViewController presentViewController:IonProfileVC animated:YES completion:nil];

    }else if ([shortcutItem.type isEqualToString:@"com.IonNews.app.Share"]){
        NSArray *activityItems = @[@"", @"", @"IonNews"];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
        [self.window.rootViewController presentViewController:activityVC animated:TRUE completion:nil];
    
    }
    
    

}


- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        // Code for old versions
    }
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    completionHandler();
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
 

}

// Newtowrk  check
- (BOOL) checkIfInternetExists {
    BOOL returnValue = YES;
    
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkConnectivity" object:@"NO"];
        returnValue = NO;
    }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkConnectivity" object:@"YES"];
    }
    // if (networkStatus == ReachableViaWiFi || networkStatus == ReachableViaWWAN) {
    return returnValue;
    // }
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability * curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self checkIfInternetExists];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    
    NSLog(@"device token %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]);


}


@end
