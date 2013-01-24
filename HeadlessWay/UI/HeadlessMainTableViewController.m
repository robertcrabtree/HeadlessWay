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
#import "HeadlessNavigationController.h"
#import "HeadlessPointerViewController.h"
#import "HeadlessNavigationBarHelper.h"
#import "HeadlessDataNodeParser.h"
#import "HeadlessGraphics.h"
#import "HeadlessCommon.h"
#import "Pointers.h"
#import "HeadlessDataNode.h"
#import "HeadlessAlarmRouter.h"

@interface HeadlessMainTableViewController () {
    HeadlessDataNode *_rootNode;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonPointer;
@property (nonatomic, retain) HeadlessDataNode *experimentSubmenu;
@property (nonatomic, retain) Pointers *pointers;
@end

@implementation HeadlessMainTableViewController

@synthesize buttonPointer, experimentSubmenu, pointers;

HEADLESS_ROTATION_SUPPORT_NONE

//#define _TEST_NOTIFICATION 1

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        HeadlessDataNodeParser *parse = [[HeadlessDataNodeParser alloc] init];
        _rootNode = [[parse parseFile:@"Headless.xml"] retain];
        [parse release];
    }
    return self;
}

- (void)popupPointer:(BOOL)alarmFired
{
    // if the user is already looking at a pointer then we don't want
    // to show another pointer
    if (![HeadlessPointerViewController inUse]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        HeadlessPointerViewController *pointerView = [storyboard instantiateViewControllerWithIdentifier:@"HeadlessPointerViewController"];
        pointerView.experimentSubmenu = [HeadlessDataNode experimentMenu];
        pointerView.pointers = self.pointers;
        pointerView.alarmFired = alarmFired;
        
        HeadlessNavigationController *navController = [[HeadlessNavigationController alloc] initWithRootViewController:pointerView];
        
        // main view controller may not be on the top of the stack
        // not sure if this is necessary but do it anyways
        UIViewController *top = self.navigationController.topViewController;
        [top presentViewController:navController animated:YES completion:nil];
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
    
    SET_LOOKS_TABLE();

    [HeadlessNavigationBarHelper setTitleAndBackButton:self.navigationItem title:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [_rootNode release];
    [buttonPointer release];
    [experimentSubmenu release];
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
    if (section < _rootNode.children.count) {
        return ((HeadlessDataNode*) [_rootNode.children objectAtIndex:section]).children.count;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SET_LOOKS_TABLE_CELL();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section < _rootNode.children.count) {
        HeadlessDataNode *groupNode = [_rootNode.children objectAtIndex:indexPath.section];
        
        HeadlessDataNode *node = [groupNode.children objectAtIndex:indexPath.row];
        cell.textLabel.text = node.name;
    } else if (indexPath.section == _rootNode.children.count) {
        cell.textLabel.text = @"Alarm Settings";
    } else {
#ifdef _TEST_NOTIFICATION
        cell.textLabel.text = @"(( xxx TEST xxx ))";
#endif
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section < _rootNode.children.count) {
        HeadlessDataNode *groupNode = [_rootNode.children objectAtIndex:section];
        title = groupNode.name;
    }
    
    return title;
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
    if (indexPath.section < _rootNode.children.count) {
        HeadlessDataNode *groupNode = [_rootNode.children objectAtIndex:indexPath.section];
        
        HeadlessDataNode *node = [groupNode.children objectAtIndex:indexPath.row];
        if (node.type == kDataNodeTypeSubMenu) {
            [self performSegueWithIdentifier:@"segueIdMainMenuToSubmenu" sender:self];
        } else if (node.type == kDataNodeTypeWebData || node.type == kDataNodeTypeWebPageFull) {
            [self performSegueWithIdentifier:@"segueIdMainMenuToBrowser" sender:self];
        } else if (node.type == kDataNodeTypeYoutube) {
            NSURL *url = [NSURL URLWithString:node.url];
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (indexPath.section == _rootNode.children.count) {
        [self performSegueWithIdentifier:@"segueIdMainMenuToNotification" sender:self];
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
    
    if (indexPath.section < _rootNode.children.count) {
        HeadlessDataNode *groupNode = [_rootNode.children objectAtIndex:indexPath.section];

        HeadlessDataNode *node = [groupNode.children objectAtIndex:indexPath.row];
        if (node.type == kDataNodeTypeSubMenu) {
            HeadlessSubMenuTableViewController *controller = [segue destinationViewController];
            controller.node = node;
        } else {
            HeadlessBrowserViewController *controller = [segue destinationViewController];
            controller.node = node;
        }
    }
}

@end
