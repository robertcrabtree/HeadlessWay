//
//  HeadlessDataNode.m
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import "HeadlessDataNode.h"

@implementation HeadlessDataNode

@synthesize type, isExperimentMenu, isVideo, name, url, children, randomExperiment;

- (id) init
{
    self = [super init];
    if (self) {
        name = nil;
        url = nil;
        type = kDataNodeTypeSubMenu;
        isExperimentMenu = NO;
        children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id) initWithElement:(TBXMLElement *)elmt
{
    self = [self init];
    if (self) {
        
        TBXMLElement *child = elmt->firstChild;
        TBXMLAttribute *attribute = elmt->firstAttribute;
        NSString *attrValue = [TBXML attributeValue:attribute];
        if ([attrValue isEqualToString:@"submenu"]) {
            type = kDataNodeTypeSubMenu;
        } else if ([attrValue isEqualToString:@"webdata"]) {
            type = kDataNodeTypeWebData;
        } else if ([attrValue isEqualToString:@"webpage"]) {
            type = kDataNodeTypeWebPageFull;
        } else if ([attrValue isEqualToString:@"youtube"]) {
            type = kDataNodeTypeYoutube;
        } else {
            NSLog(@"Error: invalid node type");
        }

        do {
            NSString *elmtName = [TBXML elementName:child];
            
            if ([elmtName isEqualToString:@"name"])
                name = [[TBXML textForElement:child] retain];
            
            if ([elmtName isEqualToString:@"url"]) {
                url = [[TBXML textForElement:child] retain];
            }
        } while ((child = child->nextSibling));
    }
    return self;
}

- (HeadlessDataNode*)randomExperiment
{
    int random = arc4random() % children.count;
    HeadlessDataNode *node = [children objectAtIndex:random];
    return node;
}

- (void)dealloc
{
    [name release];
    [url release];
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
