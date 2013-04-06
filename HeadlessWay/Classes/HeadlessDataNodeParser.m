//
//  HeadlessDataNodeParser.m
//  MasterDetail
//
//  Created by Bobby Crabtree on 11/7/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import "HeadlessDataNodeParser.h"
#import "HeadlessDataNode.h"
#import "TBXML+HTTP.h"

@interface HeadlessDataNodeParser ()
@end

@implementation HeadlessDataNodeParser

- (void)dealloc
{
    [super dealloc];
}

- (HeadlessDataNode*) parse:(TBXML *)xml
{
    HeadlessDataNode *root = nil;
    if (xml.rootXMLElement) {
        root = [[[HeadlessDataNode alloc] initWithElement:xml.rootXMLElement] autorelease];
    } else {
        NSLog(@"Error: missing root element");
    }
    return root;
}

- (HeadlessDataNode*) parseFile:(NSString *)fileName
{
    NSError *error;
    TBXML *xml = [[TBXML alloc] initWithXMLFile:fileName error:&error];
    HeadlessDataNode *root = [self parse:xml];
    [xml release];
    return root;
}

- (HeadlessDataNode*) parseUrl:(NSString *)fileName
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:fileName];
    NSData *data = [NSData dataWithContentsOfURL:url];
    TBXML *xml = [[TBXML alloc] initWithXMLData:data error:&error];
    HeadlessDataNode *root = [self parse:xml];
    [xml release];
    return root;
}

@end
