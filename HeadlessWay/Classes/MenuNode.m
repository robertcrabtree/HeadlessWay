//
//  MenuNode.m
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import "MenuNode.h"

@implementation MenuNode

@synthesize type, urlNavigation, isExperimentMenu, isExperimentLink, isVideo, name, url, children, randomExperiment;

- (id) init
{
    self = [super init];
    if (self) {
        name = nil;
        url = nil;
        type = kMenuNodeTypeMenu;
        urlNavigation = NO;
        isExperimentMenu = NO;
        isExperimentLink = NO;
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
        if ([attrValue isEqualToString:@"menu"]) {
            type = kMenuNodeTypeMenu;
        } else if ([attrValue isEqualToString:@"link"]) {
            type = kMenuNodeTypeLink;
        } else {
            type = kMenuNodeTypeVideo;
        }

        do {
            NSString *elmtName = [TBXML elementName:child];
            
            if ([elmtName isEqualToString:@"name"])
                name = [[TBXML textForElement:child] retain];
            
            if ([elmtName isEqualToString:@"url"]) {
                url = [[TBXML textForElement:child] retain];

                NSString *attrValue = [TBXML valueOfAttributeNamed:@"navigation" forElement:child];
                if (attrValue) {
                    if ([attrValue isEqualToString:@"yes"]) {
                        urlNavigation = true;
                    }
                }
            }
        } while ((child = child->nextSibling));
    }
    return self;
}

- (MenuNode*)randomExperiment
{
    int random = arc4random() % children.count;
    MenuNode *node = [children objectAtIndex:random];
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
    NSLog(@"%@- MenuNode type=%@, name=%@, navigate=%@, url=%@",
          [self spaces:indentLevel], @"link",
          self.name,
          self.urlNavigation == true ? @"yes" : @"no",
          self.url);
}

- (void) printMenu:(NSInteger)indentLevel
{
    NSLog(@"%@+ MenuNode type=%@, name=%@, children=%i",
          [self spaces:indentLevel], @"menu",
          self.name,
          self.children.count);

    for (int i = 0; i < self.children.count; i++) {
        MenuNode *child = [self.children objectAtIndex:i];
        [child print:indentLevel+1];
    }
}

- (void) print:(NSInteger)indentLevel
{
    if (self.type == kMenuNodeTypeMenu) {
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
