//
//  HeadlessDataNode.m
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import "HeadlessDataNode.h"
#import "Pointers.h"

@implementation HeadlessDataNode

static HeadlessDataNode* _gExperimentMenu = nil;

@synthesize type, isExperimentMenu, name, url, text, children, randomExperiment;

+ (HeadlessDataNode*) experimentMenu
{
    return _gExperimentMenu;
}

- (id) init
{
    self = [super init];
    if (self) {
        name = [[[NSString alloc] initWithString:@""] retain];
        url = [[[NSString alloc] initWithString:@""] retain];
        type = kDataNodeTypeSubMenu;
        isExperimentMenu = NO;
        children = [[NSMutableArray alloc] init];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////

- (void)initAttributes:(TBXMLElement *)elmt
{
    NSString *typeStr = [TBXML valueOfAttributeNamed:@"type" forElement:elmt];
    NSString *specialStr = [TBXML valueOfAttributeNamed:@"special" forElement:elmt];
    

    if ([typeStr isEqualToString:@"root"]) {
        type = kDataNodeTypeRoot;
    } else if ([typeStr isEqualToString:@"group"]) {
        type = kDataNodeTypeGroup;
    } else if ([typeStr isEqualToString:@"submenu"]) {
        type = kDataNodeTypeSubMenu;
    } else if ([typeStr isEqualToString:@"webdata"]) {
        type = kDataNodeTypeWebData;
    } else if ([typeStr isEqualToString:@"webpage"]) {
        type = kDataNodeTypeWebPageFull;
    } else if ([typeStr isEqualToString:@"youtube"]) {
        type = kDataNodeTypeYoutube;
    } else if ([typeStr isEqualToString:@"pointer"]) {
        type = kDataNodeTypePointer;
    }

    if ([specialStr isEqualToString:@"experiment"]) {
        isExperimentMenu = YES;
        if (_gExperimentMenu && self != _gExperimentMenu) {
            [_gExperimentMenu release];
        }
        _gExperimentMenu = [self retain];
    }
}

- (void)initData:(TBXMLElement *)elmt
{
    TBXMLElement *elmtName = [TBXML childElementNamed:@"name" parentElement:elmt];
    TBXMLElement *elmtUrl = [TBXML childElementNamed:@"url" parentElement:elmt];
    NSString *data = [TBXML textForElement:elmt];
    
    if (data && data.length > 0)
        text = [data retain];
    
    if (elmtName)
        name = [[TBXML textForElement:elmtName] retain];
    
    if (elmtUrl)
        url = [[TBXML textForElement:elmtUrl] retain];
}

- (void)initChildren:(TBXMLElement *)elmt
{
    TBXMLElement *child = [TBXML childElementNamed:@"node" parentElement:elmt];
    if (child) {
        do {
            HeadlessDataNode *childNode = [[HeadlessDataNode alloc] initWithElement:child];
            
            // pointers don't get added to the UI heirarchy
            if (childNode.type == kDataNodeTypePointer) {
                [[Pointers sharedInstance] addPointer:childNode];
            } else {
                [children addObject:childNode];
            }
            [childNode release];
        } while ((child = child->nextSibling));
    }
}

- (id) initWithElement:(TBXMLElement *)elmt
{
    self = [self init];
    if (self) {
        [self setElement:elmt];
    }
    return self;
}

- (void) setElement:(TBXMLElement *)elmt
{
    [self initAttributes:elmt];
    [self initData:elmt];
    [self initChildren:elmt];
}

////////////////////////////////////////////////////////////////////////

- (HeadlessDataNode*)randomExperiment
{
    int random = arc4random() % children.count;
    HeadlessDataNode *node = [children objectAtIndex:random];
    return node;
}

- (void)dealloc
{
    [_gExperimentMenu release];
    [name release];
    [url release];
    [text release];
    [children release];
    [super dealloc];
}

- (NSString*)spaces:(NSInteger)indentLevel
{
    NSString *str = @"";
    for (int i = 0; i < indentLevel; i++) {
        str = [NSString stringWithFormat:@"%@   ", str];
    }
    return str;
}

- (void) printUrl:(NSInteger)indentLevel
{
    NSLog(@"%@- HeadlessDataNode type=%@, name=%@, url=%@",
          [self spaces:indentLevel], @"link",
          self.name,
          self.url);
}

- (void) printMenu:(NSInteger)indentLevel
{
    NSLog(@"%@+ HeadlessDataNode type=%@, name=%@, children=%i",
          [self spaces:indentLevel], @"menu",
          self.name,
          self.children.count);

    for (int i = 0; i < self.children.count; i++) {
        HeadlessDataNode *child = [self.children objectAtIndex:i];
        [child print:indentLevel+1];
    }
}

- (void) print:(NSInteger)indentLevel
{
    if (self.type == kDataNodeTypeSubMenu) {
        [self printMenu:indentLevel];
    } else {
        [self printUrl:indentLevel];
    }
}

- (void) print
{
    [self print:0];
}

@end
