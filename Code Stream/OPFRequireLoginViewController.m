//
//  OPFRequireLoginViewController.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-14.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFRequireLoginViewController.h"
#import "OPFAppState.h"
#import "OPFUpdateQuery.h"
#import "NSString+OPFMD5Hash.h"

@interface OPFRequireLoginViewController ()
@end

@implementation OPFRequireLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect rect = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-108);
        
        // Init childcontrollers
        self.signupViewController = [OPFSignupViewController newFromStoryboard];
        self.loginViewController = [OPFLoginViewController new];
        
        // Set frame for childcontrollers
        self.signupViewController.view.frame = rect;
        self.loginViewController.view.frame = rect;
        
        // Add childcontrollers
        [self addChildViewController:self.signupViewController];
        [self addChildViewController:self.loginViewController];
        
        [self.view addSubview:self.loginViewController.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userRequestsLogin:(id)sender
{
    NSString* email = self.loginViewController.eMailField.text;
    NSString* password = self.loginViewController.passwordField.text;
    BOOL persistFlag = self.loginViewController.rememberUser.isOn;
    
    BOOL loginReponse = [OPFAppState loginWithEMailHash:email.opf_md5hash andPassword:password persistLogin:persistFlag];
    
    if(loginReponse == YES) {
        [self.loginViewController.view removeFromSuperview];
    } else {
        self.loginViewController.loginMessageLabel.text = NSLocalizedString(@"Wrong username or password!", @"Login failure message");
    }
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
        [OPFUpdateQuery updateWithUserName:userName EmailHash:email Website:website Location:location Age:age Bio:bio];
        [self.view addSubview:self.loginViewController.view];
        [self.signupViewController.view removeFromSuperview];
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

- (void)userRequestsSignup:(id)sender
{
    [self.view addSubview:self.signupViewController.view];
    [self.loginViewController.view removeFromSuperview];
}


@end
