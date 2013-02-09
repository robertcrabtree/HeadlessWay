////
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
#import "HeadlessGraphics.h"
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
    
    SET_LOOKS_TABLE();
    
    [HeadlessNavigationBarHelper setTitleAndBackButton:self.navigationItem title:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [HeadlessNavigationBarHelper setNavBarImage:self.navigationController.navigationBar forHomePage:NO];
    [super viewWillAppear:animated];
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

    // reflections are all going to be random. don't list them all
    if (group.isReflectionGroup)
        return 1;
    
    return group.children.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SET_LOOKS_TABLE_CELL();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    HeadlessDataNode *group = [node.children objectAtIndex:indexPath.section];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (group.isReflectionGroup) {
        cell.textLabel.text = @"Video Reflection";
    } else {
        HeadlessDataNode *groupNode = [node.children objectAtIndex:indexPath.section];
        HeadlessDataNode *n = [groupNode.children objectAtIndex:indexPath.row];
        cell.textLabel.text = n.name;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HeadlessDataNode *group = [node.children objectAtIndex:section];
    return group.name;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadlessDataNode *group = [node.children objectAtIndex:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, self.tableView.bounds.size.width, 30)];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)] autorelease];
    
    label.text = group.name;
    label.font = [UIFont boldSystemFontOfSize:label.font.pointSize];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [label sizeToFit];
    
    [headerView addSubview:label];
    [label release];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    HeadlessDataNode *group = [node.children objectAtIndex:section];

    if (!group.isReflectionGroup)
        return nil;


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
    CGFloat constrainedSize = self.tableView.frame.size.width - 40;
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 100, constrainedSize, 0)] autorelease];

    label.text = @"Reflections are short, randomized video clips intended for periodic contemplation.";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15.0];
    
    CGRect frame = label.frame;
    frame.size.width = [label.text sizeWithFont:label.font].width;
    frame.size = [label.text sizeWithFont: label.font
                  constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                      lineBreakMode:UILineBreakModeWordWrap];

    label.frame = frame;
    headerView.frame = label.frame;
//    headerView.backgroundColor = [UIColor greenColor];
//    label.backgroundColor = [UIColor redColor];

    float xCenter = self.tableView.frame.size.width / 2;
    float yCenter = frame.size.height / 2;
    
    label.textAlignment = UITextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    
    [label setCenter:CGPointMake(xCenter, yCenter)];

//    label.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [label sizeToFit];
    
    [headerView addSubview:label];
    [label release];
    return headerView;
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
    HeadlessDataNode *n = nil;

    if (group.isReflectionGroup) {
        n = group.randomNode;
    } else {
        n = [group.children objectAtIndex:indexPath.row];
    }

    if (n.type == kDataNodeTypeSubMenu) {
        HeadlessSubMenuTableViewController *subMenu = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"StoryboardIdSubMenu"];
        subMenu.node = n;
        [self.navigationController pushViewController:subMenu animated:YES];
    } else if (n.type == kDataNodeTypeVideo) {
        MPMoviePlayerViewController* moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:n.url]];
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        [moviePlayer release];
    } else {
        [self performSegueWithIdentifier:@"segueIdSubMenuToBrowser" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    HeadlessBrowserViewController *controller = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"segueIdSubMenuToBrowser"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HeadlessDataNode *group = [self.node.children objectAtIndex:indexPath.section];
        HeadlessDataNode *n = [group.children objectAtIndex:indexPath.row];
        
        if (n.type == kDataNodeTypeSubMenu) {
            NSLog(@"Error: we don't support recursive segue yet");
        } else {
            controller.node = n;
            if (![group.randomName isEqualToString:@""]) {
                controller.randomNodes = group;
            }
        }
    }
}

@end
