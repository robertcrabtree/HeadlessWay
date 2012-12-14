//
//  HeadlessSubMenuTableViewController.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/25/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadlessDataNode;

@interface HeadlessSubMenuTableViewController : UITableViewController
@property (nonatomic, retain) HeadlessDataNode *node;
@end
