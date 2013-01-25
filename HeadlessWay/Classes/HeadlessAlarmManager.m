//
//  HeadlessAlarmManager.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/11/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessAlarmManager.h"
#import "AlarmNode.h"

@implementation HeadlessAlarmManager

- (void)saveNotification:(NSDate*)date text:(NSString*)text isWarning:(BOOL)isWarning
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = text;
    localNotif.alertAction = nil;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 0;
    localNotif.repeatInterval = 0; // don't repeat
    
    if (isWarning)
        localNotif.userInfo = nil;
    else
        localNotif.userInfo = [NSDictionary dictionaryWithObject:@"Object" forKey:@"Key"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}

- (void)saveAll:(NSArray*)alarms
{
    NSLog(@"alarm manager saving...");
    
    NSMutableArray *fileData = [[NSMutableArray alloc] init];
    NSMutableArray *times = [[NSMutableArray alloc] init];
    for (int i = 0; i < alarms.count; i++) {
        AlarmNode *node = [alarms objectAtIndex:i];
        [fileData addObject:[node saveString]];
        if (node.enabled)
            [node getAllTimes:times];
    }
    
    // save our text file with notification information (times and repeat info)
	[fileData writeToFile:[self filePath] atomically:YES];
	[fileData release];
    
    // sort all the times so that it's easily to schedule the first 63 occuring notifications
    NSArray *sorted = [times sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSDate *date1 = (NSDate*) obj1;
        NSDate *date2 = (NSDate*) obj2;
        return [date1 compare:date2];
    }];
    [times release];

    static const int MAX_NOTIFY = 63; // ios only allows 64 notifications. we will store 63 + a special notify

    int daysInSeconds = 60 * 60 * 24;
    int weeksInSeconds = daysInSeconds * 7;
    int twoMinutesInSeconds = 60 * 2;

    int weekCount = 0;
    if (sorted.count > 0) {
        int cnt = 0;
        NSDate *lastTimeDate = nil;
        
        // register all alarms with iOS. we can only save 64 though
        // and repeat by week is not an option for notifications
        // we will have to emulate the "repeat" feature.
        do {
            for (NSDate *timeDate in sorted) {
                
                if (weekCount)
                    timeDate = [timeDate dateByAddingTimeInterval:weeksInSeconds * weekCount];
                lastTimeDate = timeDate;
                
                //NSString *dateString = [NSDateFormatter localizedStringFromDate:timeDate
                //                                                      dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterShortStyle];
                //NSLog(@"%02d) creating local notification: %@", cnt+1, dateString);
                
                [self saveNotification:timeDate text:@"See who you really are." isWarning:NO];
                if (++cnt == MAX_NOTIFY)
                    break;
            }
            weekCount++;
        } while (cnt < MAX_NOTIFY);
        
        if (lastTimeDate) {
            NSString *warningText = @"You have not used the Headless app in a while. Alarms will cease until you start the app again.";
            NSDate *warningDate = [lastTimeDate dateByAddingTimeInterval:twoMinutesInSeconds];
            [self saveNotification:warningDate text:warningText isWarning:YES];
        } else {
            // shouldn't happen unless a monkey messed with the code
            NSLog(@"for some reason we have a null last date");
        }

    } else {
        NSLog(@"created 0 notifications. none to create :(");
    }
}

- (void)clearAll
{
    NSLog(@"alarm manager clearing...");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (NSString*)filePath
{
    NSArray *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[dir objectAtIndex:0] stringByAppendingPathComponent:@"Alarms.txt"];
}


- (void)allAlarms:(NSMutableArray*)outAlarms
{
    NSString *myPath = [self filePath];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
	if (fileExists) {
		NSArray *values = [[NSArray alloc] initWithContentsOfFile:myPath];
        for (int i = 0; i < values.count; i++) {
            AlarmNode *node = [[AlarmNode alloc] initWithString:[values objectAtIndex:i]];
            [outAlarms addObject:node];
            [node release];
        }
		[values release];
	}
}

- (void)remove:(AlarmNode*)node
{
    // we don't really need to do anything right now since
    // the notification config view removes all 
}

- (void)refresh
{
    NSLog(@"alarm manager refreshing...");
    NSMutableArray *alarms = [[NSMutableArray alloc] init];
    [self allAlarms:alarms];
    [self clearAll];
    [self saveAll:alarms];
    [alarms release];
}

//---------------------------------------------------------------
//----------------------- Singleton Impl. -----------------------
// --------------------------------------------------------------

static HeadlessAlarmManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (HeadlessAlarmManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
    }
    
    return self;
}

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
-(void)dealloc
{
    // I'm never called!
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}
@end
