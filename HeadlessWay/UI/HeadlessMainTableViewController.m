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
#import "HeadlessDataNode.h"
#import "HeadlessAlarmRouter.h"
#import "Reachability.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HeadlessMainTableViewController () {
    HeadlessDataNode *_rootNode;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonPointer;
@property (nonatomic, retain) HeadlessDataNode *randomExperiments;
@end

@implementation HeadlessMainTableViewController

@synthesize buttonPointer, randomExperiments;

HEADLESS_ROTATION_SUPPORT_NONE

//#define _TEST_HEADLESS 1

- (void)populateRootNode
{
    
    // see if we have an internet connection
    Reachability *r = [Reachability reachabilityWithHostName:@"headless.org"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];

    // load the xml data
    if (internetStatus != NotReachable) {
        HeadlessDataNodeParser *parse = [[HeadlessDataNodeParser alloc] init];
        _rootNode = [[parse parseUrl:@"http://www.headless.org/headless-app/data.xml"] retain];
        [parse release];
    }
    
    if (_rootNode) {
        self.buttonPointer.enabled = YES;
    } else {
        self.buttonPointer.enabled = NO;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self populateRootNode];
    }
    return self;
}

- (void)popupPointer:(BOOL)alarmFired
{
    // if the user is already looking at a pointer then we don't want
    // to show another pointer. also check to make sure all xml data
    // was downloaded
    if (![HeadlessPointerViewController inUse] && _rootNode) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        HeadlessPointerViewController *pointerView = [storyboard instantiateViewControllerWithIdentifier:@"HeadlessPointerViewController"];
        pointerView.randomExperiments = [HeadlessDataNode experimentGroup];
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

- (void) actionRefresh:(id)sender
{
    [self populateRootNode];
    
    if (_rootNode) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.tableView reloadData];
    } else {
        [self showAlert:@"Unable to load data. Please connect to a network and try again."];
    }
}

- (void) headlessAlarmHandler
{
    NSLog(@"handling headlessAlarmHandler");
    [[HeadlessAlarmRouter sharedInstance] clearAlarm];
    [self popupPointer:YES];
}

- (void)showAlert:(NSString*)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonPointer.target = self;
    self.buttonPointer.action = @selector(actionPointer:);
    
    [[HeadlessAlarmRouter sharedInstance] registerHandler:self handler:@selector(headlessAlarmHandler)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [HeadlessNavigationBarHelper setTitleAndBackButton:self.navigationItem title:@""];

    if (!_rootNode) {
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(actionRefresh:)];
        self.navigationItem.leftBarButtonItem = refresh;
        [refresh release];
        [self showAlert:@"This application requires an internet connection. Please connect to a network and hit the refresh button."];
    }
    
    SET_LOOKS_TABLE();
}

- (void)viewWillAppear:(BOOL)animated
{
    [HeadlessNavigationBarHelper setNavBarImage:self.navigationController.navigationBar forHomePage:YES];
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [_rootNode release];
    [buttonPointer release];
    [randomExperiments release];
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
    
    // see if xml file was downloaded successfully
    if (_rootNode) {
        // Return the number of sections.
#ifdef _TEST_HEADLESS
        return 4;
#else
        return 3;
#endif
    }
    
    return 0;
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
#ifdef _TEST_HEADLESS
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    if (section < _rootNode.children.count) {
        headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)] autorelease];
        HeadlessDataNode *group = [_rootNode.children objectAtIndex:section];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, self.tableView.bounds.size.width, 30)];
        
        label.text = group.name;
        label.font = [UIFont boldSystemFontOfSize:label.font.pointSize];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [label sizeToFit];
        
        [headerView addSubview:label];
        [label release];
    }
    return headerView;
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
        } else if (node.type == kDataNodeTypeVideo) {
            MPMoviePlayerViewController* theMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:node.url]];
            [self presentMoviePlayerViewControllerAnimated:theMoviePlayer];
            [theMoviePlayer release];
        }
    } else if (indexPath.section == _rootNode.children.count) {
        [self performSegueWithIdentifier:@"segueIdMainMenuToNotification" sender:self];
    } else {
#ifdef _TEST_HEADLESS
        [self testHeadless];
#endif
    }
}

#ifdef _TEST_HEADLESS
- (void)testHeadless
{
    //    NSString *vid = @"http://static.clipcanvas.com/sample/clipcanvas_14348_offline.mp4";
    //    NSString *vid = @"http://192.168.0.12/~bobbycrabtree/prog_index.m3u8";
    NSString *vid = @"http://192.168.0.12/~bobbycrabtree/3B/playlist.m3u8";
    //    NSString *vid = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
    MPMoviePlayerViewController* theMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:vid]];
    [self presentMoviePlayerViewControllerAnimated:theMoviePlayer];
    [theMoviePlayer release];
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
