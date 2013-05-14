//
//  OPFProfileContainerController.h
//  Code Stream
//
//  Created by Tobias Deekens on 04.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFProfileContainerController : UIViewController

- (void)transitionToLoginViewControllerFromViewController :(UIViewController *) viewController;
- (void)transitionToSignupViewControllerFromViewController :(UIViewController *) viewController;
- (void)transitionToProfileViewControllerFromViewController :(UIViewController *) viewController;

- (void)userRequestsLogin:(id)sender;
- (void)userRequestsLogout:(id)sender;
- (void)userRequestsSignup:(id)sender;
- (void)userFinishedSignup:(id)sender;

@end
