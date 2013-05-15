//
//  OPFPostQuestionViewController.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-08.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostQuestionViewController.h"
#import "OPFUpdateQuery.h"
#import "FMResultSet.h"
#import "OPFAppState.h"
#import "OPFUser.h"
#import "OPFLoginViewController.h"
#import "OPFSignupViewController.h"
#import "NSString+OPFMD5Hash.h"

@interface OPFPostQuestionViewController ()
@end

@implementation OPFPostQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated{    
    if([OPFAppState isLoggedIn]==NO){
        self.loginView.hidden = NO;
        self.email.text = @"thomas.j.owens@gmail.com";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configureView{
    //listen for clicks
    [self.loginButton addTarget:self action:@selector(postButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    // Configure navigationbar
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView:)];
    
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(20, 375, 280, 44);
    
    //set the button's title
    [button setTitle:@"Post" forState:UIControlStateNormal];
    
    //listen for clicks
    [button addTarget:self action:@selector(postButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self.view addSubview:button];
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    loginButton.frame = CGRectMake(20, 247, 280, 44);
    
    //set the button's title
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    
    //listen for clicks
    [loginButton addTarget:self action:@selector(userRequestLogin)
     forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self.loginView addSubview:loginButton];
}

-(void) postButtonPressed{
    // Check if all fields are filled in correctly
    if([self.titleField.text isEqualToString:@""]){
        self.titleWarning.text = @"Title is missing";
        self.titleWarning.textColor = [UIColor redColor];
        self.titleWarning.hidden = NO;
    }
    if([self.bodyField.text isEqualToString:@""]){
        self.bodyTextWarning.text = @"Postbody is missing";
        self.bodyTextWarning.textColor = [UIColor redColor];
        self.bodyTextWarning.hidden = NO;
        self.generalWarningLabel.text = @"You forgot to fill in one textfield...";
        self.generalWarningLabel.hidden = NO;
    }
    
    // If required fields are not empty; update database
    if(![self.titleField.text isEqualToString:@""] && ![self.bodyField.text isEqualToString:@""]){
        
        // If update was successful, show UIAlert and go back to teh questionsview
        if([self updateDatabase]){
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your question has been posted." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [success show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        // If update was unsuccessful
        else{
            UIAlertView *emptyField = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Something terrible has happened" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [emptyField show];
        }
        
    }
}

// Update database with the data
-(BOOL) updateDatabase{
    
    NSString *title = self.titleField.text;
    NSString *body = self.bodyField.text;
    
    OPFUser *user = [OPFAppState userModel];
    NSString *userName = user.displayName;
    NSInteger userID = [user.identifier integerValue];
    NSArray *tags = [self.tagsField.text componentsSeparatedByString:@" "];
    NSMutableString *tagsString=[[NSMutableString alloc]initWithString:@""];
    
    for(NSString *s __strong in tags){
        [tagsString appendFormat:@"<%@>",s];
    }
    
    return [OPFUpdateQuery updateWithQuestionTitle:title Body:body Tags:tagsString ByUser:userName userID:userID];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField==self.titleField || textField==self.bodyField || textField==self.tagsField || textField==self.email || textField==self.password){
        [textField resignFirstResponder];
    }
    return YES;
}

// Go back to questionsview if user press cancel
-(IBAction)cancelView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) userRequestLogin{
    NSString* email = self.email.text;
    NSString* password = self.password.text;
    BOOL persistFlag = self.rememberUser.isOn;
    
    BOOL loginReponse = [OPFAppState loginWithEMailHash:email.opf_md5hash andPassword:password persistLogin:persistFlag];
    
    if(loginReponse == YES) {
        self.loginView.hidden=YES;
    } else {
        self.wrongPasswordLabel.hidden = NO;
    }
}




@end
