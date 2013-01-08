//
//  HeadlessBrowserViewController.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/25/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadlessDataNode;

#warning full website does not show up well "Scale to fit" disabled

#warning need to resize youtube and images in mobile versioned webpages

@interface HeadlessBrowserViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIBarButtonItem *buttonBack;
@property (nonatomic, retain) UIBarButtonItem *buttonForward;

@property (nonatomic, retain) HeadlessDataNode *node;
@property (nonatomic, retain) HeadlessDataNode *experimentSubmenu;
@end
