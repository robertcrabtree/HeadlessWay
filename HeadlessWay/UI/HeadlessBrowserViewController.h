//
//  HeadlessBrowserViewController.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/25/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadlessDataNode;

@interface HeadlessBrowserViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIBarButtonItem *buttonBack;
@property (nonatomic, retain) UIBarButtonItem *buttonForward;

@property (nonatomic, retain) HeadlessDataNode *node;
@property (nonatomic, retain) HeadlessDataNode *experimentSubmenu;
@end
