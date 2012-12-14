//
//  HeadlessAlarmRouter.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/8/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadlessAlarmRouter : NSObject

// 1. should be called the app delegate's didFinishLaunchingWithOptions
// method when it is invoked with a local notification (notification fired when
// app is not running)
// 2. should be called by the app delegate's didReceiveLocalNotification
// (local notification fired when running in the foreground)
// 3. should be called by the app delegate's didReceiveLocalNotification
// (local notification fired when running in the background)
- (void)postAlarm;

// should be called by the main view controller when it processes the alarm
- (void)clearAlarm;

// main view controller should register a handler
// selector will be invoked when an alarm is posted
- (void)registerHandler:(id)target handler:(SEL)handler;

+ (id)sharedInstance;
@end
