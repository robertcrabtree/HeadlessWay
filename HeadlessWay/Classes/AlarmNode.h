//
//  AlarmNode.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/28/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface AlarmNode : NSObject



/// CRAP!!
// Unfortunately we can only repeat hourly, daily, or monthly
// iOS screwed us. I'm just going to leave the code in case iOS
// gives us support for repeating.
typedef enum {
    ALARM_REPEAT_SUN = 0x01,
    ALARM_REPEAT_MON = 0x02,
    ALARM_REPEAT_TUE = 0x04,
    ALARM_REPEAT_WED = 0x08,
    ALARM_REPEAT_THU = 0x10,
    ALARM_REPEAT_FRI = 0x20,
    ALARM_REPEAT_SAT = 0x40,
    
    ALARM_REPEAT_ALL = 0X7F,
} AlarmRepeatFlags;

- (id) initWithString:(NSString *)str;
- (NSString*)dateString;
- (NSString*)repeatString;
- (NSString*)saveString;
- (void)toggleRepeat:(NSInteger)flag;
- (void)enableRepeat:(NSInteger)flag;
- (void)disableRepeat:(NSInteger)flag;
- (BOOL)repeatEnabled:(NSInteger)flag;

- (BOOL)isDuplicateOf:(AlarmNode*)node;

- (NSComparisonResult)compare:(AlarmNode*)anotherNode;

- (void)getAllTimes:(NSMutableArray*)times;

@property (nonatomic, assign) NSInteger hour;       // 24-hour to capture am/pm
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger repeat;
@property (nonatomic, assign) BOOL updated;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, assign) BOOL enabled;
@end
