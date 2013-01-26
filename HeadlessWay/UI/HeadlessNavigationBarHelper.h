//
//  HeadlessNavigationBarHelper.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 1/4/13.
//  Copyright (c) 2013 HeadlessWay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadlessNavigationBarHelper : NSObject
+(void)setTitleAndBackButton:(UINavigationItem*)navItem title:(NSString*)title;
+(void)setNavBarImage:(UINavigationBar*)navItem forHomePage:(BOOL)homePage;
@end
