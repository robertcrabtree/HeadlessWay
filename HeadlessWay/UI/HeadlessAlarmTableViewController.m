//
//  HeadlessAlarmTableViewController.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/25/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessAlarmTableViewController.h"
#import "HeadlessAlarmItemViewController.h"
#import "HeadlessNavigationController.h"
#import "HeadlessAlarmRepeatTableViewController.h"
#import "HeadlessAlarmManager.h"
#import "HeadlessCommon.h"
#import "AlarmNode.h"

@interface HeadlessAlarmTableViewController () {
    UIBarButtonItem *_editButton;
    UIBarButtonItem *_doneEditButton;
    UIBarButtonItem *_flexButton;
    UIBarButtonItem *_addButton;
    NSMutableArray *_alarms;
    UILabel *_labelNoAlarms;
}

@property (nonatomic, retain) AlarmNode *addingNode;
@property (nonatomic, retain) AlarmNode *editingNode;
@property (nonatomic, retain) AlarmNode *highlightNode;
@property (nonatomic, assign) NSInteger editingIndex;

@end

@implementation HeadlessAlarmTableViewController

@synthesize addingNode, editingNode, highlightNode, editingIndex;

HEADLESS_ROTATION_SUPPORT_NONE

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self
                                                                    action:@selector(actionEdit:)];
        _doneEditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(actionDoneEdit:)];
        _flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
        _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(actionAdd:)];
        _alarms = [[ NSMutableArray alloc] init];
        
        _labelNoAlarms = nil;
    }
    return self;
}

-(void)dealloc
{
    [_editButton release];
    [_doneEditButton release];
    [_flexButton release];
    [_addButton release];
    [_alarms release];
    [_labelNoAlarms release];
    [addingNode release];
    [editingNode release];
    [highlightNode release];
    [super dealloc];
}

- (void)saveData
{
    [[HeadlessAlarmManager sharedInstance] clearAll];
    [[HeadlessAlarmManager sharedInstance] saveAll:_alarms];
}

- (NSString*)filePath
{
    NSArray *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[dir objectAtIndex:0] stringByAppendingPathComponent:@"Alarms.txt"];
}

- (void)toggleEditingMode:(BOOL)editing
{
    // if a cell is being edited for delete because user swiped the cell
    // then we need to disable editing mode so we can put all cells into
    // editing mode and properly display the 'minus' as expected
    if (self.tableView.editing && editing) {
        [self setEditing:NO animated:YES];
        [self.tableView setEditing:NO animated:YES];
    }
    
    [self setEditing:editing animated:YES];
    [self.tableView setEditing:editing animated:YES];
}

- (void) actionEdit:(id)sender
{
    [self toggleEditingMode:YES];
    [self toggleButtonEdit:NO];
}

- (void)doneEditing
{
    [self toggleEditingMode:NO];
    [self toggleButtonEdit:YES];
    _editButton.enabled = (_alarms.count != 0);
}

- (void) actionDoneEdit:(id)sender
{
    [self doneEditing];
}

- (void) updateNode:(AlarmNode*)node
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    HeadlessAlarmItemViewController *itemView = [storyboard instantiateViewControllerWithIdentifier:@"HeadlessAlarmItemViewController"];
    itemView.node = node;
    HeadlessNavigationController *navController = [[HeadlessNavigationController alloc] initWithRootViewController:itemView];
    [self presentViewController:navController animated:YES completion:NULL];
    [navController release];
}

- (void) actionAdd:(id)sender
{
    AlarmNode *node = [[AlarmNode alloc] init];
    self.addingNode = node;
    [self updateNode:node];
    [node release];
}

- (void) switchChange:(id)sender
{
    UISwitch *switchView = (UISwitch*)sender;
    UITableViewCell *cell = (UITableViewCell*)switchView.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AlarmNode *node = [_alarms objectAtIndex:indexPath.row];
    node.enabled = switchView.on;
    [self saveData];
}

-(void)toggleButtonEdit:(BOOL)edit
{
    NSMutableArray *arr;
    if (edit) {
        arr = [[NSMutableArray alloc] initWithObjects:_editButton, _flexButton, _addButton, nil];
    } else {
        arr = [[NSMutableArray alloc] initWithObjects:_doneEditButton, _flexButton, _addButton, nil];
    }
    self.toolbarItems = arr;
    [arr release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [[HeadlessAlarmManager sharedInstance] allAlarms:_alarms];
}

-(void)showAlarmText
{
    if (_labelNoAlarms == nil) {
        
        _labelNoAlarms = [[UILabel alloc] initWithFrame:CGRectZero];
        
        CGFloat constrainedSize = self.tableView.frame.size.width;
        float xCenter = self.tableView.frame.size.width / 2 - self.tableView.frame.origin.x;
        float yCenter = self.tableView.frame.size.height / 2 -
            self.tableView.frame.origin.y -
            self.tableView.sectionHeaderHeight;
        
        NSString *text = @"Add alarms to remind you to see who you really are.";
        _labelNoAlarms.font = [UIFont boldSystemFontOfSize:_labelNoAlarms.font.pointSize];
        CGRect frame = _labelNoAlarms.frame;
        frame.size.width = [text sizeWithFont:_labelNoAlarms.font].width;
        frame.size = [text sizeWithFont: _labelNoAlarms.font
                      constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                          lineBreakMode:UILineBreakModeWordWrap];

        _labelNoAlarms.frame = frame;
        _labelNoAlarms.text = text;
        _labelNoAlarms.backgroundColor = [UIColor clearColor];
        _labelNoAlarms.textColor = [UIColor whiteColor];
        _labelNoAlarms.textAlignment = UITextAlignmentCenter;
        _labelNoAlarms.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];

        [_labelNoAlarms setCenter:CGPointMake(xCenter, yCenter)];
        _labelNoAlarms.lineBreakMode = NSLineBreakByWordWrapping;
        _labelNoAlarms.numberOfLines = 0;
        [_labelNoAlarms sizeToFit];
        
        /*
         // show a red dot in center of table
        UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(xCenter, yCenter, 5.0f, 5.0f)];
        vv.backgroundColor = [UIColor redColor];
        [self.tableView addSubview:vv];
         */
    }
    
    BOOL skipAdd = NO;
    for (UIView *view in self.tableView.subviews) {
        if (view == _labelNoAlarms) {
            skipAdd = YES;
            break;
        }
    }
    
    if (!skipAdd) {
        [self.tableView addSubview:_labelNoAlarms];
    }
}

-(void)hideAlarmText
{
    if (_labelNoAlarms) {
        [_labelNoAlarms removeFromSuperview];
    }
}

- (BOOL)checkDuplicates:(AlarmNode*)node1 skipIndex:(NSInteger)skipIndex
{
    for (int i = 0; i < _alarms.count; i++) {
        AlarmNode *node2 = [_alarms objectAtIndex:i];
        if (node1 != node2 && skipIndex != i) {
            if ([node1 isDuplicateOf:node2]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You can't have duplicate alarms"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [alert release];
                return YES;
            }
        }
    }
    return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // if we are adding a node (modal view controller for adding a node is done)
    if (self.addingNode) {
        if (self.addingNode.updated) {
            if (![self checkDuplicates:self.addingNode skipIndex:-1]) {
                [_alarms addObject:self.addingNode];
                [self saveData];
                self.highlightNode = self.addingNode;
            }
        }
        self.addingNode = nil;
    }
    if (self.editingNode) {
        if (self.editingNode.updated) {
            if (![self checkDuplicates:self.editingNode skipIndex:self.editingIndex]) {
                AlarmNode *editMe = [_alarms objectAtIndex:self.editingIndex];
                editMe.time = self.editingNode.time;
                editMe.repeat = self.editingNode.repeat;
                [self saveData];
                self.highlightNode = editMe;
            }
        }
        self.editingNode = nil;
    }
    
    [self doneEditing];
    
    if (_alarms.count == 0)
        [self showAlarmText];
    else
        [self hideAlarmText];
    
    _editButton.enabled = (_alarms.count != 0);
    [self.navigationController setToolbarHidden:NO animated:animated];
    if (!self.editing) {
        [self toggleButtonEdit:YES];
    }
    
    if (_alarms.count > 1) {
        [_alarms sortUsingComparator:^(id obj1, id obj2) {
            AlarmNode *alarm1 = (AlarmNode*) obj1;
            AlarmNode *alarm2 = (AlarmNode*) obj2;
            return [alarm1 compare:alarm2];
        }];
    }
    [self.tableView reloadData];
    
    // first let's scroll to the newly added or modified cell
    // in viewDidAppear we will select and deselect the cell
    // so the user knows what changes they made
    if (self.highlightNode) {
        NSIndexPath *path = [self findIndexPath:self.highlightNode];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        
        // only scroll if not already visible
        if (![[self.tableView visibleCells] containsObject:cell]) {
            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

-(NSIndexPath*)findIndexPath:(AlarmNode*)node
{
    for (int i = 0; i < _alarms.count; i++) {
        AlarmNode *n = [_alarms objectAtIndex:i];
        if (n == node) {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    return nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // highlight the last edited or added cell
    if (self.highlightNode) {
        NSIndexPath *path = [self findIndexPath:self.highlightNode];
        [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.tableView deselectRowAtIndexPath:path animated:YES];
    }
    self.highlightNode = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _alarms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AlarmNode *node = [_alarms objectAtIndex:indexPath.row];
    cell.textLabel.text = [node dateString];
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchView.on = node.enabled;
    [switchView addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchView;
    [switchView release];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.editingAccessoryView = nil;
    
    cell.detailTextLabel.text = [node repeatString];

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AlarmNode *node = [_alarms objectAtIndex:indexPath.row];
        [[HeadlessAlarmManager sharedInstance] remove:node];
        [_alarms removeObjectAtIndex:indexPath.row];
        if (_alarms.count == 0) {
            [self showAlarmText];
            [self doneEditing];
        }
        [self saveData];
        NSArray *arr = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
        [arr release];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmNode *node1 = [_alarms objectAtIndex:indexPath.row];
    AlarmNode *node2 = [[AlarmNode alloc] init];
    node2.time = node1.time;
    node2.repeat = node1.repeat;
    self.editingNode = node2; // temporary node so we don't overwrite the original date
    self.editingIndex = indexPath.row;
    [self updateNode:node2];
    [node2 release];
}

 - (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}


@end
