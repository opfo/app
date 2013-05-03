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
#import "OPFUserProfileViewController.h"
#import "OPFActivityViewController.h"
#import "OPFFavoritesViewController.h"
#import "OPFAppState.h"
#import "UIColor+OPFHEX.h"

@interface OPFTabbedHomeViewController ()

@property(strong, nonatomic) UINavigationController *questionsViewNavigationController;
@property(strong, nonatomic) UINavigationController *profileSearchViewNavigationController;
@property(strong, nonatomic) UINavigationController *userProfileNavigationController;
@property(strong, nonatomic) UINavigationController *activityViewNavigationController;
@property(strong, nonatomic) UINavigationController *favoritesViewNavigationController;

@property(strong, nonatomic) OPFQuestionsViewController *questionsViewController;
@property(strong, nonatomic) OPFProfileSearchViewController *profileSearchViewController;
@property(strong, nonatomic) OPFUserProfileViewController *userProfileViewController;
@property(strong, nonatomic) OPFActivityViewController *activityViewController;
@property(strong, nonatomic) OPFFavoritesViewController *favoritesViewController;

- (void)opfSetupView;

@end

@implementation OPFTabbedHomeViewController

const int TabbedBarHeight = 44;

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
    self.userProfileViewController = [OPFUserProfileViewController newFromStoryboard];
    self.activityViewController = [OPFActivityViewController new];
    self.favoritesViewController = [OPFFavoritesViewController new];
    
    self.userProfileViewController.user = [OPFAppState userModel];

    self.questionsViewNavigationController = [[UINavigationController new] initWithRootViewController:self.questionsViewController];
    self.profileSearchViewNavigationController = [[UINavigationController new] initWithRootViewController:self.profileSearchViewController];
    self.userProfileNavigationController = [[UINavigationController new] initWithRootViewController:self.userProfileViewController];
    self.activityViewNavigationController = [[UINavigationController new] initWithRootViewController:self.activityViewController];
    self.favoritesViewNavigationController = [[UINavigationController new] initWithRootViewController:self.favoritesViewController];
    
    [self setViewControllers:[NSMutableArray arrayWithObjects:
                              self.questionsViewNavigationController,
                              self.activityViewNavigationController,
                              self.favoritesViewNavigationController,
                              self.profileSearchViewNavigationController,
                              self.userProfileNavigationController,
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
