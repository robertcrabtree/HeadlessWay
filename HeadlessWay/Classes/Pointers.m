//
//  Pointers.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/3/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "Pointers.h"
#import "HeadlessDataNode.h"

@interface Pointers() {
    NSMutableArray *_pointers;
}
@end

static Pointers* sharedInstance = nil;

@implementation Pointers

- (void)addPointer:(HeadlessDataNode*)pointer
{
    [_pointers addObject:pointer];
}

- (NSString*)nextPointer
{
    if (!_pointers) {
        NSLog(@"Error: pointer not init");
        return @"Error";
    }

    int random = arc4random() % _pointers.count;
    HeadlessDataNode *pointer = [_pointers objectAtIndex:random];
//    NSLog(@"random %d=%@", random, pointer.text);
    return pointer.text;
}

/////////////////////////////////////// SINGLETON IMPL ///////////////////////////////

+ (Pointers *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _pointers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
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
