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
#import "NSString+OPFMD5Hash.h"
#import "OPFUpdateQuery.h"
#import "OPFDBInsertionIdentifier.h"
#import "NSDateFormatter+OPFDateFormatters.h"

@interface OPFProfileContainerController ()

@property(strong, nonatomic) OPFLoginViewController *loginViewController;
@property(strong, nonatomic) OPFSignupViewController *signupViewController;
@property(strong, nonatomic) OPFUserProfileViewController *profileViewController;

- (void)transitionToLoginViewControllerFromViewController :(UIViewController *) viewController;
- (void)transitionToSignupViewControllerFromViewController :(UIViewController *) viewController;
- (void)transitionToProfileViewControllerFromViewController :(UIViewController *) viewController;

@end

@implementation OPFProfileContainerController

static const NSTimeInterval TransitionDuration = .5f;

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
    CGRect rect = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-108);
	
    //Alloc init the contained view controllers
    self.loginViewController = [OPFLoginViewController new];
    self.signupViewController = [OPFSignupViewController newFromStoryboard];
    self.profileViewController = [OPFUserProfileViewController newFromStoryboard];
    
    //Set the frame sizes
    self.loginViewController.view.frame = rect;
    self.signupViewController.view.frame = rect;
    self.profileViewController.view.frame = rect;
    
    //self.profileViewController.nextResponder = self;
    
    //Add them to self (container) as child
    [self addChildViewController:self.loginViewController];
    [self addChildViewController:self.signupViewController];
    [self addChildViewController:self.profileViewController];
    
    //Let childs know that they have been moved into a parent <-> child relationship
    [self.loginViewController didMoveToParentViewController:self];
    [self.signupViewController didMoveToParentViewController:self];
    [self.profileViewController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (OPFAppState.sharedAppState.isLoggedIn) {
        self.profileViewController.user = OPFAppState.sharedAppState.user;
        
        [self.view addSubview:self.profileViewController.view];
    } else {
        [self.view addSubview:self.loginViewController.view];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)opfSetupView
{
    self.title = NSLocalizedString(@"Login", @"Login View controller title");
}

#pragma mark - Transition methods

- (void)transitionToLoginViewControllerFromViewController :(UIViewController *) viewController;
{
    self.title = NSLocalizedString(@"Login", @"Login View controller title");
    
    [self transitionFromViewController:viewController
                      toViewController:self.loginViewController
                              duration:TransitionDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
}

- (void)transitionToSignupViewControllerFromViewController :(UIViewController *) viewController;
{
    self.title = NSLocalizedString(@"Signup", @"Signup View controller title");
    
    UIBarButtonItem *dismissSignupButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSignupViewController:)];
	self.navigationItem.leftBarButtonItem = dismissSignupButton;
    
    [self transitionFromViewController:viewController
                      toViewController:self.signupViewController
                              duration:TransitionDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
}

- (void)transitionToProfileViewControllerFromViewController :(UIViewController *) viewController;
{
    self.title = NSLocalizedString(@"Profile", @"Profile View controller title");
    
    self.profileViewController.user = OPFAppState.sharedAppState.user;
    
    [self transitionFromViewController:viewController
                      toViewController:self.profileViewController
                              duration:TransitionDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
}

#pragma mark - TabbedViewController methods

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"tab-me";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return NSLocalizedString(@"My Profile", @"Profile View Controller tab title");
}

#pragma mark - Asking New Questions
- (IBAction)dismissSignupViewController:(id)sender
{
    self.navigationItem.leftBarButtonItem = nil;
    
	[self transitionToLoginViewControllerFromViewController:self.signupViewController];
}

#pragma mark - IBOutlet responder chain catches

- (void)userRequestsLogin:(id)sender
{    
    NSString* email = self.loginViewController.eMailField.text;
    NSString* password = self.loginViewController.passwordField.text;
    BOOL persistFlag = self.loginViewController.rememberUser.isOn;
    
    BOOL loginReponse = [OPFAppState.sharedAppState loginWithEmailHash:email.opf_md5hash password:password persistLogin:persistFlag];
    
    if(loginReponse == YES) {
        [self transitionToProfileViewControllerFromViewController:self.loginViewController];
    } else {
        self.loginViewController.loginMessageLabel.text = NSLocalizedString(@"Wrong username or password!", @"Login failure message");
    }
}

- (void)userRequestsLogout:(id)sender
{
    [OPFAppState.sharedAppState logout];
    [self transitionToLoginViewControllerFromViewController:self.profileViewController];
}

- (void)userRequestsSignup:(id)sender
{
    [self transitionToSignupViewControllerFromViewController:self.loginViewController];
}

- (void)userFinishedSignup:(id)sender
{
    // Get all data from the fields
    NSString *userName = self.signupViewController.name.text;
    NSString *email = self.signupViewController.email.text.opf_md5hash;
    NSString *website = self.signupViewController.website.text;
    NSString *location = self.signupViewController.location.text;
    NSInteger age = [self.signupViewController.age.text intValue];
    NSString *bio = self.signupViewController.bio.text;
    
    // Check if fields are correctly filled
    BOOL emailFilled = ![self.signupViewController.email.text isEqualToString:@""];
    BOOL passwordFilled = ![self.signupViewController.password.text isEqualToString:@""];
    BOOL repeatedPasswordFilled = ![self.signupViewController.repeatedPassword.text isEqualToString:@""];
    BOOL nameFilled = ![self.signupViewController.name.text isEqualToString:@""];
    BOOL passwordMatch = [self.signupViewController.password.text isEqualToString:self.signupViewController.repeatedPassword.text];
    
    // Check so email is correctly filled
    NSString *regexpForEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexpForEmail];
    BOOL correctEmail = [emailPredicate evaluateWithObject:self.signupViewController.email.text];
    
    // Set notificationlabels
    if(emailFilled && passwordFilled && repeatedPasswordFilled && nameFilled && passwordMatch && correctEmail){
            
        // Current date
        NSString *date = [NSDateFormatter opf_currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
            
        int id = [OPFDBInsertionIdentifier getNextUserId];
            
        // Query to the SO db
        NSArray* args = @[@(id), @0, date, userName, email, date, website, location, @(age), bio, @0, @0, @0];
        NSArray *col = @[@"id", @"reputation", @"creation_date", @"display_name", @"email_hash", @"last_access_date", @"website_url", @"location", @"age", @"about_me", @"views", @"up_votes", @"down_votes"];
            [OPFUpdateQuery insertInto:@"users" forColumns:col values:args auxiliaryDB:NO];
            
            
        // Query to the auxiliary db to keep it in sync with the SO db
        args = @[@(id), userName];
        col = @[@"object_id", @"index_string"];
        [OPFUpdateQuery insertInto:@"users_index" forColumns:col values:args auxiliaryDB:YES];
        
        [self transitionToLoginViewControllerFromViewController:self.signupViewController];
    }
    else{
        self.signupViewController.signUpNotification.hidden = NO;
        if(!emailFilled)
            self.signupViewController.emailFieldNotification.hidden = NO;
        if(!passwordFilled)
            self.signupViewController.passwordFieldNotification.hidden = NO;
        if(!repeatedPasswordFilled)
            self.signupViewController.repeatedPasswordFieldNotification.hidden = NO;
        if(!nameFilled)
            self.signupViewController.nameFieldNotification.hidden = NO;
        if(!passwordMatch){
            self.signupViewController.repeatedPasswordFieldNotification.text = @"Passwords don't match";
            self.signupViewController.repeatedPasswordFieldNotification.hidden = NO;
        }
        if(!correctEmail){
            self.signupViewController.emailFieldNotification.text = @"Not correct email";
            self.signupViewController.emailFieldNotification.hidden = NO;
        }
    }
}

@end
