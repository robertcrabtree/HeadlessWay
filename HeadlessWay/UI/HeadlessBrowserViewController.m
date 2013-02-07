//
//  HeadlessBrowserViewController.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 11/25/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "HeadlessBrowserViewController.h"
#import "HeadlessNavigationBarHelper.h"
#import "HeadlessDataNode.h"
#import "HeadlessGraphics.h"
#import "HeadlessCommon.h"

@interface HeadlessBrowserViewController ()

@end

@implementation HeadlessBrowserViewController

@synthesize webView, buttonBack, buttonForward, node, randomNodes;

HEADLESS_ROTATION_SUPPORT

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
    [webView release];
    [buttonBack release];
    [buttonForward release];
    [node release];
    [randomNodes release];
    [super dealloc];
}

- (void)actionNext:(id)sender
{
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.randomNodes.randomNode.url]];
    [self.webView loadRequest:requestURL];
}

- (void)actionBack:(id)sender
{
    [self.webView goBack];
}

- (void)actionForward:(id)sender
{
    [self.webView goForward];
}

- (void)actionRefresh:(id)sender
{
    [self.webView reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView setDelegate:self];
    
    if (self.node.type == kDataNodeTypeWebPageFull) {
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack:)];
        UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
        fixed.width = 30;
        UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(actionForward:)];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(actionRefresh:)];
        
        self.toolbarItems = [NSArray arrayWithObjects:back, fixed, forward, flex, refresh, nil];

        [self.navigationController setToolbarHidden:NO animated:YES];
        
        [back release];
        [fixed release];
        [forward release];
        [flex release];
        [refresh release];
        
        self.buttonBack = back;
        self.buttonForward = forward;
        self.buttonBack.enabled = NO;
        self.buttonForward.enabled = NO;
    }

    if (self.node.type == kDataNodeTypeWebData || self.node.type == kDataNodeTypeWebPageFull) {
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.node.url]];
        [self.webView loadRequest:requestURL];
        NSLog(@"url=%@", self.node.url);
    } else if (self.node.type == kDataNodeTypeYoutube) {
        NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head>\
                                <body style=\"background:#33ff66;margin-top:0px;margin-left:0px\"><div>\
                                <object width=\"320\" height=\"480\">\
                                <param name=\"movie\" value=\"%@\"></param>\
                                <param name=\"wmode\" value=\"transparent\"></param>\
                                <embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"320\" height=\"480\"></embed>\
                                </object></div></body></html>",node.url,node.url];
        
        [self.webView loadHTMLString:htmlString baseURL:nil];
    } else {
        NSLog(@"Error: invalid node type in browser");
    }

    if (self.randomNodes != nil) {
        NSString *buttonText = [NSString stringWithFormat:@"Random %@", randomNodes.randomName];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:buttonText style:UIBarButtonItemStyleBordered target:self action:@selector(actionNext:)];
        self.navigationItem.rightBarButtonItem = nextButton;
        [nextButton release];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [HeadlessNavigationBarHelper setNavBarImage:self.navigationController.navigationBar forHomePage:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // this prevents a crash if view controller is popped off the stack before page loads
    if (self.webView.loading)
        [self.webView stopLoading];
    [self.webView setDelegate:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (self.node.type == kDataNodeTypeWebPageFull) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.buttonBack.enabled = (self.webView.canGoBack);
    self.buttonForward.enabled = (self.webView.canGoForward);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.buttonBack.enabled = (self.webView.canGoBack);
    self.buttonForward.enabled = (self.webView.canGoForward);
}

@end
