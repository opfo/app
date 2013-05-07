//
//  OPFWebViewController.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-06.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFWebViewController.h"
#import "OPFAppDelegate.h"

@interface OPFWebViewController ()

@end

@implementation OPFWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    [self.webview loadRequest:[[NSURLRequest alloc]initWithURL:self.page]];
    self.prevPage.target = self;
    self.prevPage.action = @selector(prevPageButtonClicked:);
    self.nextPage.target = self;
    self.nextPage.action = @selector(nextPageButtonClicked:);
    self.refreshPage.target = self;
    self.refreshPage.action = @selector(refreshPageButtonClicked:);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openInSafariButtonClicked:)];
}

-(void) prevPageButtonClicked: (id) paramSender{
    if(self.webview.canGoBack)
        [self.webview goBack];
}

-(void) nextPageButtonClicked: (id) paramSender{
    if(self.webview.canGoForward)
        [self.webview goForward];
}

-(void) refreshPageButtonClicked: (id) paramSender{
    if(self.webview.canGoBack)
        [self.webview reload];
}

-(void) openInSafariButtonClicked: (id) paramSender{
    [[UIApplication sharedApplication] openURL:self.page];
}

@end
