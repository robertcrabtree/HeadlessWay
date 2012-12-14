//
//  MenuNode.h
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

typedef enum {
    kMenuNodeTypeMenu = 0,
    kMenuNodeTypeLink,
    kMenuNodeTypeVideo,
} MenuNodeType;

@interface MenuNode : NSObject

- (id) initWithElement:(TBXMLElement *)elmt;

@property (nonatomic, assign) MenuNodeType type;
@property (nonatomic, assign) BOOL urlNavigation;
@property (nonatomic, assign) BOOL isExperimentMenu;
@property (nonatomic, assign) BOOL isExperimentLink;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableArray *children;

@property (nonatomic, readonly) MenuNode *randomExperiment;
@end
