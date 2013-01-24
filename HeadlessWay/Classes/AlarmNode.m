//
//  AlarmNode.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/28/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "AlarmNode.h"

@implementation AlarmNode

@synthesize hour, minute, repeat, updated, enabled;

static const char *DAY_ALL = "Every day";
static const char *DAY_NONE = "Never";
static const char *DAY_SUN = "Sun";
static const char *DAY_MON = "Mon";
static const char *DAY_TUE = "Tue";
static const char *DAY_WED = "Wed";
static const char *DAY_THU = "Thu";
static const char *DAY_FRI = "Fri";
static const char *DAY_SAT = "Sat";

- (void)print
{
    NSLog(@"%02d:%02d%@ (%@)", self.hour % 12, self.minute,
          self.hour > 12 ? @"PM" : @"AM",
          self.enabled ? @"enabled" : @"disabled");
}

- (void)commonInit
{
    //[self print];
}

- (id) init
{
    self = [super init];
    if (self) {
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDate *now = [[NSDate alloc] init];
        NSUInteger flags = (NSHourCalendarUnit | NSMinuteCalendarUnit);
        NSDateComponents *time = [calendar components:flags fromDate:now];
        hour = time.hour;
        minute = time.minute;
        repeat = ALARM_REPEAT_ALL;   // no repeat
        enabled = 1;
        [now release];
        [self commonInit];
    }
    return self;
}

- (id) initWithString:(NSString *)str
{
    self = [super init];
    if (self) {
        NSArray *chunks = [str componentsSeparatedByString:@":"];
        if (chunks.count == 4) {
            hour = [(NSString*)[chunks objectAtIndex:1] integerValue];
            minute = [(NSString*)[chunks objectAtIndex:2] integerValue];
            repeat = [(NSString*)[chunks objectAtIndex:3] integerValue];
            enabled = (BOOL)[(NSString*)[chunks objectAtIndex:0] integerValue];
            [self commonInit];
        } else {
            NSLog(@"Error: expecting 3 tokens in AlarmNode init string");
        }
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSDate*)dateWithflags:(NSUInteger)flags
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *now = [[NSDate alloc] init];
    NSDateComponents *comp = [calendar components:flags fromDate:now];
    [comp setHour:self.hour];
    [comp setMinute:self.minute];
    [now release];
    return [calendar dateFromComponents:comp];
}

- (NSDate*)time
{
    return [self dateWithflags:NSHourCalendarUnit | NSMinuteCalendarUnit];
}

- (void)setTime:(NSDate *)time
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger flags = (NSHourCalendarUnit | NSMinuteCalendarUnit);
    NSDateComponents *comp = [calendar components:flags fromDate:time];
    self.hour = comp.hour;
    self.minute = comp.minute;
}

- (NSString*)dateString
{
#warning verify that 11am/pm, 12am/pm, and 1am/pm works
    return [NSString stringWithFormat:@"%d:%02d %@", self.hour %12 == 0 ? 12 : self.hour %12 , self.minute, self.hour >= 12 ? @"PM" : @"AM"];
}

- (NSString*)repeatString
{
    NSString *days = @"";
    const char *dayText[] = {
        DAY_SUN,
        DAY_MON,
        DAY_TUE,
        DAY_WED,
        DAY_THU,
        DAY_FRI,
        DAY_SAT
    };
    
    int count = 0;
    for (int i = 0; i < 7; i ++) {
        if ([self repeatEnabled:1<<i]) {
            if (count > 0)
                days = [NSString stringWithFormat:@"%@ %s", days, dayText[i]];
            else
                days = [NSString stringWithFormat:@"%s", dayText[i]];
            count++;
        }
    }
    
    if (count == 0)
        return [NSString stringWithCString:DAY_NONE encoding:NSASCIIStringEncoding];
    else if (count == 7)
        return [NSString stringWithCString:DAY_ALL encoding:NSASCIIStringEncoding];
    return days;
}

- (NSString*)saveString
{
    return [NSString stringWithFormat:@"%d:%02d:%02d:%d",
            self.enabled, self.hour, self.minute, self.repeat];
}

- (void)toggleRepeat:(NSInteger)flag
{
    if ((self.repeat & flag))
        [self disableRepeat:flag];
    else
        [self enableRepeat:flag];
}

- (void)enableRepeat:(NSInteger)flag
{
    self.repeat |= flag;
}

- (void)disableRepeat:(NSInteger)flag
{
    self.repeat &= ~flag;
}

- (BOOL)repeatEnabled:(NSInteger)flag
{
    return (self.repeat & flag) > 0;
}

- (BOOL)isDuplicateOf:(AlarmNode*)node
{
    BOOL isDuplicate = NO;
    
    NSMutableArray *times1 = [[NSMutableArray alloc] init];
    [self getAllTimes:times1];
    
    NSMutableArray *times2 = [[NSMutableArray alloc] init];
    [node getAllTimes:times2];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    for (NSDate* date1 in times1) {
        NSDateComponents *comp1 = [calendar components:flags fromDate:date1];
        for (NSDate *date2 in times2) {
            NSDateComponents *comp2 = [calendar components:flags fromDate:date2];
            if (comp1.day == comp2.day &&
                comp1.hour == comp2.hour &&
                comp1.minute == comp2.minute) {
                isDuplicate = YES;
                goto exit;
            }
        }
    }
exit:
    
    [times1 release];
    [times2 release];
    
    return isDuplicate;
}

- (NSComparisonResult)compare:(AlarmNode*)anotherNode
{
    return [self.time compare:anotherNode.time];
}

- (void)getAllTimes:(NSMutableArray*)times
{
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDate *nowDate = [NSDate date];
    NSDate *nodeDate = [self dateWithflags:flags];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *nowComponents = [calendar components:flags fromDate:nowDate];

    int daysInSeconds = 60 * 60 * 24;
    int weeksInSeconds = daysInSeconds * 7;
    
    int currDayOfWeek = nowComponents.weekday;
    for (int i = 0; i < 7; i++) {
        
        int index = currDayOfWeek-1;  // node sunday = 0, ios sunday = 1 (hence the minus 1)
        
        if (((self.repeat >> index) & 0x01) > 0) {
            NSDate *saveDate = nodeDate;
            
            // increment the day of week
            if (i > 0) { // we don't need to increment the day of week on the first iteration
                saveDate = [saveDate dateByAddingTimeInterval:daysInSeconds * i];
            }
            
            // if date has already passed, then increment by one week
            if ([nowDate compare:saveDate] == NSOrderedDescending) {
                // time has already passed (now is later than node time)
                saveDate = [saveDate dateByAddingTimeInterval:weeksInSeconds];
            }
            
            [times addObject:saveDate];
            
            /*
            NSString *dateString = [NSDateFormatter localizedStringFromDate:saveDate
                                                                  dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterShortStyle];
            NSLog(@"computed save date/time = %@", dateString);
             */
        }
        
        // increment day of week (sun-sat)
        currDayOfWeek++;
        if (currDayOfWeek == 8)
            currDayOfWeek = 1; // reset to sunday
    }
}

@end
