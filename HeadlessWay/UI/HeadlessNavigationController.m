//
//  HeadlessNavigationController.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 1/11/13.
//  Copyright (c) 2013 HeadlessWay. All rights reserved.
//

#import "HeadlessNavigationController.h"
#import "HeadlessBrowserViewController.h"

#warning need rotation constraints for iOS 5

@implementation HeadlessNavigationController

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *controller = self.topViewController;
    if (controller) {
        return [controller supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    UIViewController *controller = self.topViewController;
    if (controller) {
        return [controller shouldAutorotate];
    }
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIViewController *controller = self.topViewController;
    if (controller) {
        return [controller preferredInterfaceOrientationForPresentation];
    }
    return UIInterfaceOrientationPortrait;
}

@end
