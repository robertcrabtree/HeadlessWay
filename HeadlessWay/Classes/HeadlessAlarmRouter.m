//
//  HeadlessAlarm.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/8/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessAlarmRouter.h"

@interface HeadlessAlarmRouter() {
    SEL _handler;
    BOOL _needsHandled;
}
@property (nonatomic, retain) id sender;

@end

@implementation HeadlessAlarmRouter

@synthesize sender;

static HeadlessAlarmRouter *sharedInstance = nil;

- (void)postAlarm
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HeadlessAlarmFired" object:nil];
    _needsHandled = YES;
}

- (void)clearAlarm
{
    _needsHandled = NO;
}

- (void)handleIt
{
    if (_handler) {
        [self.sender performSelector:_handler];
    }
}

- (void)alarmHandler:(id)sender
{
    [self handleIt];
}

- (void)registerHandler:(id)target handler:(SEL)handler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmHandler:) name:@"HeadlessAlarmFired" object:nil];
    _handler = handler;
    self.sender = target;

    // perhaps there is one waiting already
    if (_needsHandled)
        [self handleIt];
}

/////////////////////////////////////// SINGLETON IMPL ///////////////////////////////

+ (HeadlessAlarmRouter *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _handler = NULL;
        _needsHandled = NO;
    }

    return self;
}

-(void)dealloc
{
    [sender release];
    [super dealloc];
}

+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    
}

- (id)autorelease {
    return self;
}

@end
