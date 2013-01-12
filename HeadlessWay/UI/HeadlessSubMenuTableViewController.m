//
//  HeadlessSubMenuTableViewController.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/25/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessSubMenuTableViewController.h"
#import "HeadlessBrowserViewController.h"
#import "HeadlessNavigationBarHelper.h"
#import "HeadlessDataNode.h"
#import "HeadlessCommon.h"

@interface HeadlessSubMenuTableViewController ()
@end

@implementation HeadlessSubMenuTableViewController

@synthesize node;

HEADLESS_ROTATION_SUPPORT_NONE

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [node release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [HeadlessNavigationBarHelper setTitleAndBackButton:self.navigationItem title:self.node.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return node.children.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HeadlessDataNode *group = [node.children objectAtIndex:section];
    return group.children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    HeadlessDataNode *groupNode = [node.children objectAtIndex:indexPath.section];
    HeadlessDataNode *n = [groupNode.children objectAtIndex:indexPath.row];
    cell.textLabel.text = n.name;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HeadlessDataNode *group = [node.children objectAtIndex:section];
    return group.name;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
    // Navigation logic may go here. Create and push another view controller.
    HeadlessDataNode *group = [self.node.children objectAtIndex:indexPath.section];
    HeadlessDataNode *n = [group.children objectAtIndex:indexPath.row];
    
    if (n.type == kDataNodeTypeSubMenu) {
        HeadlessSubMenuTableViewController *subMenu = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"StoryboardIdSubMenu"];
        subMenu.node = n;
        [self.navigationController pushViewController:subMenu animated:YES];
    } else if (n.type == kDataNodeTypeYoutube) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        NSURL *url = [NSURL URLWithString:n.url];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [self performSegueWithIdentifier:@"segueIdSubMenuToBrowser" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    HeadlessDataNode *group = [self.node.children objectAtIndex:indexPath.section];
    HeadlessDataNode *n = [group.children objectAtIndex:indexPath.row];
    
    if (n.type == kDataNodeTypeSubMenu) {
        NSLog(@"Error: we don't support recursive segue yet");
    } else {
        HeadlessBrowserViewController *controller = [segue destinationViewController];
        controller.node = n;
        if (group.isExperimentMenu) {
            controller.experimentSubmenu = group;
        }
    }
}

@end
