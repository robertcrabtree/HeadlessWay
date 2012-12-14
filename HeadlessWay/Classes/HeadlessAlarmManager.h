//
//  HeadlessAlarmManager.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/11/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlarmNode;

@interface HeadlessAlarmManager : NSObject

// save all alarms with the OS
- (void)saveAll:(NSArray*)alarms;

// remove all saved alarms from the OS
- (void)clearAll;

// returns an array of AlarmNode objects
- (void)allAlarms:(NSMutableArray*)outAlarms;

- (void)remove:(AlarmNode*)node;

- (void)refresh;

// get the single instance of this class
+ (id)sharedInstance;
@end
