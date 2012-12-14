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
    kDataNodeTypeSubMenu = 0,
    kDataNodeTypeWebData,       // will not show navigation buttons in UIWebView
    kDataNodeTypeWebPageFull,   // will show navigation buttons in UIWebView
    kDataNodeTypeYoutube,
} HeadlessDataNodeType;

@interface HeadlessDataNode : NSObject

- (id) initWithElement:(TBXMLElement *)elmt;

@property (nonatomic, assign) HeadlessDataNodeType type;
@property (nonatomic, assign) BOOL isExperimentMenu;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableArray *children;

@property (nonatomic, readonly) HeadlessDataNode *randomExperiment;
@end
