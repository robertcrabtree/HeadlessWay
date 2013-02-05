//
//  Pointers.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/3/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HeadlessDataNode;

@interface Pointers : NSObject
- (NSString*)nextPointer;
- (void)addPointer:(HeadlessDataNode*)pointer;
+ (id)sharedInstance;
@end
