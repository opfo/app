//
//  OPFSignupViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 02.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSignupViewController.h"

@interface OPFSignupViewController ()

@end

@implementation OPFSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self opfSetupView];
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

- (void)opfSetupView
{
    self.title = NSLocalizedString(@"Signup", @"Signup View controller title");
}

#pragma mark - Container Controller methods

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"%@ %@", self.class, @" WILL move to parent view controller");
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"%@ %@", self.class, @" DID move to parent view controller");
}

@end
