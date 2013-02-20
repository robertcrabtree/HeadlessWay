//
//  HeadlessDataNodeParser.h
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class HeadlessDataNode;

@interface HeadlessDataNodeParser : NSObject
- (HeadlessDataNode*) parseFile:(NSString *)fileName;
- (HeadlessDataNode*) parseUrl:(NSString *)fileName;
@end
