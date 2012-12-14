//
//  HeadlessAlarmViewController.h
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/7/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmNode.h"

@interface HeadlessAlarmItemViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) AlarmNode *node;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonSave;
@end
