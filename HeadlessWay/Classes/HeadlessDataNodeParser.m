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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:fileName];
    NSData *data = [NSData dataWithContentsOfURL:url];
    TBXML *xml = [[TBXML alloc] initWithXMLData:data error:&error];
    
    HeadlessDataNode *root = nil;
    if (xml.rootXMLElement) {
        root = [[[HeadlessDataNode alloc] initWithElement:xml.rootXMLElement] autorelease];
    } else {
        NSLog(@"Error: missing root element");
    }
    
    [xml release];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return root;
}

@end
