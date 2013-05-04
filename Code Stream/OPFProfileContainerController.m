//
//  OPFProfileContainerController.m
//  Code Stream
//
//  Created by Tobias Deekens on 04.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFProfileContainerController.h"
#import "OPFAppState.h"
#import "OPFLoginViewController.h"
#import "OPFSignupViewController.h"
#import "OPFUserProfileViewController.h"

@interface OPFProfileContainerController ()

@property(strong, nonatomic) OPFLoginViewController *loginViewController;
@property(strong, nonatomic) OPFSignupViewController *signupViewController;
@property(strong, nonatomic) OPFUserProfileViewController *profileViewController;

- (void)transitionToLoginViewControllerFromViewController :(UIViewController *) viewController;
- (void)transitionToSignupViewController :(UIViewController *) viewController;
- (void)transitionToProfileViewController :(UIViewController *) viewController;

@end

@implementation OPFProfileContainerController

static const int transitionDuration = .5f;

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
	
    //Alloc init the contained view controllers
    self.loginViewController = [OPFLoginViewController new];
    self.signupViewController = [OPFSignupViewController new];
    self.profileViewController = [OPFUserProfileViewController new];
    
    //Add them to self (container) as child
    [self addChildViewController:self.loginViewController];
    [self addChildViewController:self.signupViewController];
    [self addChildViewController:self.profileViewController];
    
    //Let childs know that they have been moved into a parent <-> child relationship
    [self.loginViewController didMoveToParentViewController:self];
    [self.signupViewController didMoveToParentViewController:self];
    [self.profileViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Transition methods

- (void)transitionToLoginController :(UIViewController *) viewController;
{
    [self transitionFromViewController:viewController
                      toViewController:self.loginViewController
                              duration:transitionDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
}

- (void)transitionToSignupController :(UIViewController *) viewController;
{
    [self transitionFromViewController:viewController
                      toViewController:self.signupViewController
                              duration:transitionDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
}

- (void)transitionToProfileController :(UIViewController *) viewController;
{
    [self transitionFromViewController:viewController
                      toViewController:self.profileViewController
                              duration:transitionDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
}

#pragma mark - TabbedViewController methods

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return [OPFAppState isLoggedIn] ? @"tab-me" : @"tab-login";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return [OPFAppState isLoggedIn] ? NSLocalizedString(@"My Profile", @"Profile View Controller tab title") : NSLocalizedString(@"Login", @"Login View Controller tab title");
}

@end
