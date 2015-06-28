//
//  AppDelegate.m
//  NicoleHBD
//
//  Created by bobiechen on 6/23/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Enable storing and querying data from Local Datastore. Remove this line if you don't want to
    // use Local Datastore features or want to use cachePolicy.
    [Parse enableLocalDatastore];
    
    // ****************************************************************************
    // Uncomment this line if you want to enable Crash Reporting
    // [ParseCrashReporting enable];
    //
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"HEH8DGG9z2ZtnrCiku8cmCI5ZXDUfaHlMXzu1mNJ"
                  clientKey:@"OGjbbcPxgTptxgYDxnDSZOHy189SPk9VZAKMzikm"];
    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    // [PFFacebookUtils initializeFacebook];
    // ****************************************************************************
    
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        UIUserNotificationSettings* setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound|
                                                                                            UIUserNotificationTypeAlert|
                                                                                            UIUserNotificationTypeBadge
                                                                                categories:nil];
        [application registerUserNotificationSettings:setting];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                        UIRemoteNotificationTypeAlert|
                                                        UIRemoteNotificationTypeSound];
    }

    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Successfully registered for remote notification.");
    NSString *tokenString = [NSString stringWithFormat:@"%@",deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"device token: %@", tokenString);
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    [PFPush subscribeToChannelInBackground:@"happybirthday" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
        } else {
            NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
        }
    }];

    [PFPush subscribeToChannelInBackground:@"updates" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
        } else {
            NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for remote notiification. Error: %@", [error localizedDescription]);
}

#pragma mark - app life-cycle management
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
