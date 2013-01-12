//
//  HeadlessAlarmItemViewController.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/7/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessAlarmItemViewController.h"
#import "HeadlessCommon.h"
#import "HeadlessAlarmRepeatTableViewController.h"

@interface HeadlessAlarmItemViewController ()
@property (nonatomic, retain) UIDatePicker *picker;
@property (nonatomic, retain) AlarmNode *tmpNode; // if user hits cancel we don't want to modify self.node passed in from caller
@end

@implementation HeadlessAlarmItemViewController

@synthesize node, buttonCancel, buttonSave, picker, tmpNode;

HEADLESS_ROTATION_SUPPORT_NONE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [node release];
    [buttonCancel release];
    [buttonSave release];
    [picker release];
    [tmpNode release];
    [super dealloc];
}

- (void)addDatePicker
{
    UIDatePicker *pick = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.picker = pick;
    [pick release];
    
	CGSize pickerSize = [pick sizeThatFits:CGSizeZero];
    CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationHeight = [[self.navigationController navigationBar] frame].size.height;
    CGFloat pickerHeight = pickerSize.height;
    
    CGFloat pickerX = windowHeight - statusBarHeight - navigationHeight - pickerHeight;
    
    CGRect pickerFrame = CGRectMake(0, pickerX, pickerSize.width, pickerSize.height);
    self.picker.frame = pickerFrame;
    
    self.picker.hidden = NO;
    self.picker.datePickerMode = UIDatePickerModeTime;
    self.picker.date = self.node.time;
    
    [self.view addSubview:self.picker];
}

- (void) actionCancel:(id)sender
{
    self.node.updated = NO;
    [self dismissModalViewControllerAnimated:YES];
}

- (void) actionSave:(id)sender
{
    if (node.repeat == 0x00) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select days to repeat"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    } else {
        if (self.tmpNode != nil)
            self.node.repeat = self.tmpNode.repeat;
        self.node.updated = YES;
        self.node.time = self.picker.date;
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buttonCancel.target = self;
    self.buttonCancel.action = @selector(actionCancel:);
    self.buttonSave.target = self;
    self.buttonSave.action = @selector(actionSave:);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tmpNode = nil;

    [self addDatePicker];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path) {
        [self.tableView deselectRowAtIndexPath:path animated:animated];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = @"Repeat";

    NSString *text = [self.node repeatString];
    if (self.tmpNode != nil)
        text = [self.tmpNode repeatString];
    
    cell.detailTextLabel.text = text;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (indexPath.section == 0) {
        if (self.tmpNode == nil) {
            AlarmNode *temp = [[AlarmNode alloc] init];
            temp.time = self.node.time;
            temp.repeat = self.node.repeat;
            self.tmpNode = temp;
            [temp release];
        }

        HeadlessAlarmRepeatTableViewController *controller = [segue destinationViewController];
        controller.node = self.tmpNode;
    }
}


@end
