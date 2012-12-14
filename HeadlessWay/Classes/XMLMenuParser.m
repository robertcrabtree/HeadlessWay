//
//  XMLMenuParser.m
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import "XMLMenuParser.h"
#import "HeadlessDataNode.h"

@interface XMLMenuParser ()
@end

@implementation XMLMenuParser

@synthesize experiments;

- (void)dealloc
{
    [experiments release];
    [super dealloc];
}

- (void) traverseElement:(TBXMLElement *)element array:(NSMutableArray *)nodes
{
    do {
        
        NSString *elmtName = [TBXML elementName:element];
        TBXMLAttribute *attribute = element->firstAttribute;
        
        // get the attribute
        if ([elmtName isEqualToString:@"node"]) {
            if (attribute) {
                NSString *attrName = [TBXML attributeName:attribute];
                NSString *attrValue = [TBXML attributeValue:attribute];
                
                if ([attrName isEqualToString:@"type"]) {
                    if ([attrValue isEqualToString:@"menu"]) {
                        NSString *specialValue = [TBXML valueOfAttributeNamed:@"special" forElement:element];
                        HeadlessDataNode *node = [[HeadlessDataNode alloc] initWithElement:element];
                        if (specialValue) {
                            node.isExperimentMenu = YES;
                            experiments = [node retain];
                        }
                        if (node) {
                            [nodes addObject:node];
                            if (element->firstChild) {
                                NSMutableArray *children = [[NSMutableArray alloc] init];
                                node.children = children;
                                [self traverseElement:element->firstChild array:children];
                                [children release];
                            }
                            [node release];
                        }
                    } else if ([attrValue isEqualToString:@"link"]) {
                        HeadlessDataNode *node = [[HeadlessDataNode alloc] initWithElement:element];
                        if (node) {
                            TBXMLElement *parent = element->parentElement;
                            NSString *specialValue = [TBXML valueOfAttributeNamed:@"special" forElement:parent];
                            if (specialValue) {
                                node.isExperimentLink = YES;
                            }
                            [nodes addObject:node];
                            if (element->firstChild)
                                [self traverseElement:element->firstChild array:nodes];
                            [node release];
                        }
                    } else if ([attrValue isEqualToString:@"video"]) {
                        HeadlessDataNode *node = [[HeadlessDataNode alloc] initWithElement:element];
                        if (node) {
                            [nodes addObject:node];
                            if (element->firstChild)
                                [self traverseElement:element->firstChild array:nodes];
                            [node release];
                        }
                    } else {
                        NSLog(@"Error: invalid attribute expecting 'link' or 'menu' not %@", attrValue);
                    }
                } else {
                    NSLog(@"Error: attribute name is not 'type'");
                }
            } else {
                NSLog(@"Error: node does not have a 'type' atrribute");
            }
        }
    } while ((element = element->nextSibling));
}

- (void) parse:(TBXML*)tbxml primary:(HeadlessDataNode*)primary secondary:(HeadlessDataNode*)secondary
{
    if (tbxml.rootXMLElement) {
        
        NSString *rootName = [TBXML elementName:tbxml.rootXMLElement];
        if ([rootName isEqualToString:@"root"]) {
            TBXMLElement *primaryElement = [TBXML childElementNamed:@"primary" parentElement:tbxml.rootXMLElement];
            TBXMLElement *secondaryElement = [TBXML childElementNamed:@"secondary" parentElement:tbxml.rootXMLElement];
            
            if (!primaryElement) {
                NSLog(@"Error: missing primary element");
            }
            if (!secondaryElement) {
                NSLog(@"Error: missing secondary element");
            }
            if (primaryElement && secondaryElement) {
                [self traverseElement:primaryElement->firstChild array:primary.children];
                [self traverseElement:secondaryElement->firstChild array:secondary.children];
            }
        } else {
            NSLog(@"Error: invalid root name");
        }
    } else {
        NSLog(@"Error: missing root element");
    }
}

- (void) parseFile:(NSString *)fileName primary:(HeadlessDataNode*)primary secondary:(HeadlessDataNode*)secondary
{
    NSError *error;
    TBXML *xml = [[TBXML alloc] initWithXMLFile:fileName error:&error];
    [self parse:xml primary:primary secondary:secondary];
    [xml release];
}

@end
