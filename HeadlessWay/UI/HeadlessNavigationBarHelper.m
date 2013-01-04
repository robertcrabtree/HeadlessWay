//
//  HeadlessNavigationBarHelper.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 1/4/13.
//  Copyright (c) 2013 HeadlessWay. All rights reserved.
//

#import "HeadlessNavigationBarHelper.h"

@implementation HeadlessNavigationBarHelper

+(void)setTitleAndBackButton:(UINavigationItem*)navItem title:(NSString*)title
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    navItem.backBarButtonItem = backButton;
    [backButton release];

    if (title && title.length > 0)
        navItem.title = title;
}

@end
