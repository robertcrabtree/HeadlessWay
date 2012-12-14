//
//  HeadlessMainTableViewController.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/25/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessMainTableViewController.h"
#import "HeadlessSubMenuTableViewController.h"
#import "HeadlessBrowserViewController.h"
#import "HeadlessPointerViewController.h"
#import "HeadlessDataNodeParser.h"
#import "Pointers.h"
#import "HeadlessDataNode.h"
#import "HeadlessAlarmRouter.h"

@interface HeadlessMainTableViewController () {
    HeadlessDataNode *_primaryNode;
    HeadlessDataNode *_secondaryNode;
    BOOL _isPointerViewActive;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonPointer;
@property (nonatomic, retain) HeadlessDataNode *experimentsNode;
@property (nonatomic, retain) Pointers *pointers;
@end

@implementation HeadlessMainTableViewController

@synthesize buttonPointer, experimentsNode, pointers;

//#define _TEST_NOTIFICATION 1

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _primaryNode = [[HeadlessDataNode alloc] init];
        _secondaryNode = [[HeadlessDataNode alloc] init];
        
        HeadlessDataNodeParser *parse = [[HeadlessDataNodeParser alloc] init];
        [parse parseFile:@"Headless.xml" primary:_primaryNode secondary:_secondaryNode];
        experimentsNode = [parse.experiments retain];
        [parse release];
        _isPointerViewActive = NO;
    }
    return self;
}

- (void)popupPointer:(BOOL)alarmFired
{
    // if the user is already looking at a pointer then we don't want
    // to show another pointer
    if (!_isPointerViewActive) {
        _isPointerViewActive = YES;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        HeadlessPointerViewController *pointerView = [storyboard instantiateViewControllerWithIdentifier:@"HeadlessPointerViewController"];
        pointerView.experimentsNode = experimentsNode;
        pointerView.pointers = self.pointers;
        pointerView.alarmFired = alarmFired;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pointerView];
        [self presentViewController:navController animated:YES completion:nil];
        [navController release];
    }
}

- (void) actionPointer:(id)sender
{
    [self popupPointer:NO];
}

- (void) headlessAlarmHandler
{
    NSLog(@"handling headlessAlarmHandler");
    [[HeadlessAlarmRouter sharedInstance] clearAlarm];
    [self popupPointer:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonPointer.target = self;
    self.buttonPointer.action = @selector(actionPointer:);

    Pointers *p = [[Pointers alloc] init];
    self.pointers = p;
    [p release];

    [[HeadlessAlarmRouter sharedInstance] registerHandler:self handler:@selector(headlessAlarmHandler)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isPointerViewActive = NO;
}

- (void)dealloc
{
    [_primaryNode release];
    [_secondaryNode release];
    [buttonPointer release];
    [experimentsNode release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
#ifdef _TEST_NOTIFICATION
    return 4;
#else
    return 3;
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return _primaryNode.children.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if (indexPath.section == 0) {
        HeadlessDataNode *node = [_primaryNode.children objectAtIndex:indexPath.row];
        cell.textLabel.text = node.name;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Alarm Settings";
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"Resources";
    } else {
#ifdef _TEST_NOTIFICATION
        cell.textLabel.text = @"(( xxx TEST xxx ))";
#endif
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    if (indexPath.section == 0) {
        HeadlessDataNode *node = [_primaryNode.children objectAtIndex:indexPath.row];
        if (node.type == kDataNodeTypeSubMenu) {
            [self performSegueWithIdentifier:@"segueIdMainMenuToSubmenuLinks" sender:self];
        } else {
            [self performSegueWithIdentifier:@"segueIdMainMenuToBrowser" sender:self];
        }
    } else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"segueIdMainMenuToNotification" sender:self];
    } else if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"segueIdMainMenuToSubmenuMore" sender:self];
    } else {
#ifdef _TEST_NOTIFICATION
        [self testNotification];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
#endif
    }
}

#ifdef _TEST_NOTIFICATION
- (void)testNotification
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"have %d notifications scheduled", notifications.count);
    
    NSDate *now = [NSDate date];
    
    now = [now dateByAddingTimeInterval:10];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        NSLog(@"Error: notification is null");
    
    localNotif.fireDate = now;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = @"This is a test notification";
    localNotif.alertAction = nil;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 0;
    localNotif.repeatInterval = 0;

    // real notification
    localNotif.userInfo = [NSDictionary dictionaryWithObject:@"Object" forKey:@"Key"];
    
    // warning notification
//    localNotif.userInfo = nil;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}
#endif

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (indexPath.section == 0) {
        HeadlessDataNode *node = [_primaryNode.children objectAtIndex:indexPath.row];
        if (node.type == kDataNodeTypeSubMenu) {
            HeadlessSubMenuTableViewController *controller = [segue destinationViewController];
            controller.node = node;
        } else {
            HeadlessBrowserViewController *controller = [segue destinationViewController];
            controller.node = node;
        }
    } else if (indexPath.section == 1) {
        // no-op
    } else if (indexPath.section == 2) {
        HeadlessSubMenuTableViewController *controller = [segue destinationViewController];
        controller.node = _secondaryNode;
    }
}

@end
