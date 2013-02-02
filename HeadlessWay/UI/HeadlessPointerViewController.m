//
//  HeadlessPointerViewController.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/8/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessPointerViewController.h"
#import "HeadlessBrowserViewController.h"
#import "HeadlessNavigationBarHelper.h"
#import "Pointers.h"
#import "HeadlessDataNode.h"
#import "HeadlessCommon.h"

@interface HeadlessPointerViewController ()

@end

@implementation HeadlessPointerViewController

@synthesize experimentSubmenu, pointers, buttonRefresh, buttonExperiment, textView, alarmFired;

static BOOL _inUse = NO;

HEADLESS_ROTATION_SUPPORT_NONE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [experimentSubmenu release];
    [pointers release];
    [buttonRefresh release];
    [buttonExperiment release];
    [textView release];
    [super dealloc];
}

- (void)nextPointer
{
    if (self.pointers) {
        NSString *pointer = [self.pointers nextPointer];
        self.textView.text = pointer;
    }
}

- (void) actionDone:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) actionExperiment:(id)sender
{
    [self performSegueWithIdentifier:@"segueIdPointerToExperiment" sender:self];
}

- (void) actionRefresh:(id)sender
{
    
    [self nextPointer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self nextPointer];

    if (self.alarmFired) {
        // @TODO: maybe we will do something with this someday
        // for now nothing, but we do have the option of
        // distinguishing if this is viewing because of
        // an alarm
    }

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    self.buttonRefresh.action = @selector(actionRefresh:);
    self.buttonRefresh.target = self;
    self.buttonExperiment.action = @selector(actionExperiment:);
    self.buttonExperiment.target = self;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame: textView.frame];
    imageView.image = [UIImage imageNamed:@"paper-background3"];
    imageView.frame = self.textView.frame;
    [self.view addSubview: imageView];
    [self.view sendSubviewToBack: imageView];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [imageView release];
    
    [HeadlessNavigationBarHelper setTitleAndBackButton:self.navigationItem title:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [HeadlessNavigationBarHelper setNavBarImage:self.navigationController.navigationBar forHomePage:NO];
    [super viewWillAppear:animated];
    
    // add observer to format the text vertically centered
    // we must do this before we set the text...
    [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    // we are resettting the text so the observer will reformat the text
    // vertically. this is necessary in case we do an experiment then come back
    // text needs to be reformatted (center verticaly)
    NSString *text = self.textView.text;
    self.textView.text = text;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _inUse = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _inUse = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    if (tv) {
        // center the text vertically...
        CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
        topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
        tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    } else {
        NSLog(@"Error: UITextView is null (o_O)");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HeadlessDataNode *randomExperiment = experimentSubmenu.randomExperiment;
    HeadlessBrowserViewController *controller = [segue destinationViewController];
    controller.node = randomExperiment;
    controller.experimentSubmenu = experimentSubmenu;
}

+(BOOL)inUse
{
    return _inUse;
}

@end
