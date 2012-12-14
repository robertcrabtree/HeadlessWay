//
//  HeadlessAppDelegate.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/25/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessAppDelegate.h"
#import "HeadlessPointerViewController.h"
#import "HeadlessAlarmRouter.h"
#import "HeadlessAlarmManager.h"

@implementation HeadlessAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void)showDebug:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

    UILocalNotification *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
//    [self showDebug:notif != nil ? @"got notif" : @"no notif"];
        
    [self updateAlarmManager];
    if (notif) {
        [self showTime:@"didFinishLaunchingWithOptions" notif:notif];
        
        // if userInfo is nil, then this is not an actual alarm
        // it is a warning message no need to show pointer
        if (notif.userInfo != nil) {
            [self showPointer];
        }
    }

    return YES;
}


- (void)showTime:(NSString*)tag notif:(UILocalNotification*)notif
{
    NSDate *date = [NSDate date];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    NSString *dateStringNotif = [NSDateFormatter localizedStringFromDate:notif.fireDate
                                                          dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    NSLog(@"incoming notification: %@ ---> %@ (tag=%@) (text=%@)", dateString, dateStringNotif, tag, notif.alertBody);
}


- (void)showPointer
{
    // this will tell the main view controller to load the pointer view controller
    [[HeadlessAlarmRouter sharedInstance] postAlarm];
}

- (void)updateAlarmManager
{
    [[HeadlessAlarmManager sharedInstance] refresh];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // user hit "ok" button (didn't cancel)
    if (buttonIndex == 1) {
        [self showPointer];
    }
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    [self updateAlarmManager];
    
    // If userInfo is nil then this is not an actual "seeing" alarm
    // It mean's it's the "warning" alarm once we've reached 64 alarms
    if (notif && notif.userInfo != nil) {
        if (app.applicationState == UIApplicationStateActive) {
            // If application is active in the foreground then user did not see
            // a local notification. So we must do this manually with an alert view
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notif.alertBody
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            
            [self showTime:@"didReceiveLocalNotification UIApplicationStateActive" notif:notif];
        } else {
            [self showTime:@"didReceiveLocalNotification UIApplicationStateBackground" notif:notif];
            // If application is in background or not running then the user already
            // got an alert. Simply do what we gotta do.
            [self showPointer];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
