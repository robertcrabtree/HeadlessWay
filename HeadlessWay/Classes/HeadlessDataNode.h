//
//  HeadlessDataNode.h
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

typedef enum {
    kDataNodeTypeRoot = 0,
    kDataNodeTypeGroup,
    kDataNodeTypeSubMenu,
    kDataNodeTypeWebData,       // will not show navigation buttons in UIWebView
    kDataNodeTypeWebPageFull,   // will show navigation buttons in UIWebView
    kDataNodeTypeVideo,
    kDataNodeTypePointer,
} HeadlessDataNodeType;

@interface HeadlessDataNode : NSObject

- (id) initWithElement:(TBXMLElement *)elmt;
- (void) setElement:(TBXMLElement *)elmt;

+ (HeadlessDataNode*) experimentMenu;

@property (nonatomic, assign) HeadlessDataNodeType type;
@property (nonatomic, assign) BOOL isExperimentMenu;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *randomName;
@property (nonatomic, retain) NSMutableArray *children;

@property (nonatomic, readonly) HeadlessDataNode *randomNode;
@end
