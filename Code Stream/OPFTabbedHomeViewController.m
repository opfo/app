//
//  OPFTabbedHomeViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 30.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTabbedHomeViewController.h"
#import "OPFQuestionsViewController.h"
#import "OPFProfileSearchViewController.h"
#import "OPFActivityViewController.h"
#import "OPFProfileContainerController.h"
#import "OPFTagBrowserViewController.h"
#import "OPFAppState.h"
#import "UIColor+OPFHEX.h"

@interface OPFTabbedHomeViewController ()

@property(strong, nonatomic) UINavigationController *questionsViewNavigationController;
@property(strong, nonatomic) UINavigationController *profileSearchViewNavigationController;
@property(strong, nonatomic) UINavigationController *activityViewNavigationController;
@property(strong, nonatomic) UINavigationController *profileContainerNavigationViewController;
@property(strong, nonatomic) UINavigationController *tagBrowserViewNavigationController;

@property(strong, nonatomic) OPFQuestionsViewController *questionsViewController;
@property(strong, nonatomic) OPFProfileSearchViewController *profileSearchViewController;
@property(strong, nonatomic) OPFActivityViewController *activityViewController;
@property(strong, nonatomic) OPFProfileContainerController *profileContainerController;
@property(strong, nonatomic) OPFTagBrowserViewController *tagBrowserViewController;

- (void)opfSetupView;

@end

@implementation OPFTabbedHomeViewController

static const NSInteger TabbedBarHeight = 44;

- (id)init
{
    self = [super initWithTabBarHeight:TabbedBarHeight];

    if (self) {
        [self opfSetupView];
    }

    return self;
}

- (void)opfSetupView
{
    self.questionsViewController = [OPFQuestionsViewController new];
    self.profileSearchViewController = [OPFProfileSearchViewController new];
    self.activityViewController = [OPFActivityViewController new];
    self.profileContainerController = [OPFProfileContainerController new];
    self.tagBrowserViewController = [OPFTagBrowserViewController new];

    self.questionsViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.questionsViewController];
    self.profileSearchViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.profileSearchViewController];
    self.profileContainerNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.profileContainerController];
    self.activityViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.activityViewController];
    self.tagBrowserViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tagBrowserViewController];

    [self setViewControllers:[NSMutableArray arrayWithObjects:
                              self.questionsViewNavigationController,
                              self.tagBrowserViewNavigationController,
                              self.activityViewNavigationController,
                              self.profileSearchViewNavigationController,
                              self.profileContainerNavigationViewController,
                            nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = [UIColor opf_colorWithHexValue:0xe2e7ed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
