//
//  HeadlessPointerViewController.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/8/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuNode;
@class Pointers;

@interface HeadlessPointerViewController : UIViewController
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonRefresh;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonExperiment;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@property (nonatomic, retain) MenuNode *experimentsNode;
@property (nonatomic, retain) Pointers *pointers;
@property (nonatomic, assign) BOOL alarmFired; // a seeing alarm has fired
@end
