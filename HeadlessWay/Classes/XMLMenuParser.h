//
//  XMLMenuParser.h
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class MenuNode;

@interface XMLMenuParser : NSObject
- (void) parseFile:(NSString *)fileName primary:(MenuNode*)primary secondary:(MenuNode*)secondary;
@property (nonatomic, readonly) MenuNode *experiments;
@end
