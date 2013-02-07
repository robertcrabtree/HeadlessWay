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

- (HeadlessDataNode*) parseFile:(NSString *)fileName
{
    NSError *error;
    TBXML *xml = [[TBXML alloc] initWithXMLFile:fileName error:&error];
    
    HeadlessDataNode *root = nil;
    if (xml.rootXMLElement) {
        root = [[[HeadlessDataNode alloc] initWithElement:xml.rootXMLElement] autorelease];
    } else {
        NSLog(@"Error: missing root element");
    }
    
    [xml release];
    return root;
}

#warning This is asynchronous, need to work with this
- (HeadlessDataNode*) parseURL:(NSString *)url
{
    TBXML *xml = [[TBXML alloc] initWithURL:[NSURL URLWithString:url] success:nil failure:nil];
    
    HeadlessDataNode *root = nil;
    if (xml.rootXMLElement) {
        root = [[[HeadlessDataNode alloc] initWithElement:xml.rootXMLElement] autorelease];
    } else {
        NSLog(@"Error: missing root element");
    }
    
    [xml release];
    return root;
}

@end
