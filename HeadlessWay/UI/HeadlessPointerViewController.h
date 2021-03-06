//
//  HeadlessPointerViewController.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/8/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadlessDataNode;

@interface HeadlessPointerViewController : UIViewController
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonRefresh;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonExperiment;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@property (nonatomic, retain) HeadlessDataNode *randomExperiments;
@property (nonatomic, assign) BOOL alarmFired; // a seeing alarm has fired

+(BOOL)inUse;
@end
