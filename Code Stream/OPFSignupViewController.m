//
//  OPFSignupViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 02.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSignupViewController.h"
#import "OPFAppDelegate.h"

@interface OPFSignupViewController ()

@end

@implementation OPFSignupViewController

+ (instancetype)newFromStoryboard
{
	// This be a hack, do not ship stuff like this!
	NSAssert(OPFAppDelegate.sharedAppDelegate.storyboard != nil, @"Our hack to instantiate OPFUserProfileViewController from the storyboard failed as the root view controller wasn’t from the storyboard.");
	OPFSignupViewController *signupViewController = [OPFAppDelegate.sharedAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"UserSignupViewController"];
	return signupViewController;
}

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
    UITapGestureRecognizer *tapOutsideBioTextView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapOutsideBioTextView];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField==self.email ||textField==self.password ||textField==self.repeatedPassword ||textField==self.name ||textField==self.age ||textField==self.location ||textField==self.website){
        [textField resignFirstResponder];
    }
    return YES;
}

-(void) dismissKeyboard{
    [self.bio resignFirstResponder];
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
