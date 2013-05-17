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
#import "UIColor+OPFAppColors.h"

#import <BlocksKit.h>

@interface OPFPostQuestionViewController ()
@property (strong, nonatomic) OPFLoginViewController *loginViewController;
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
    [super viewWillAppear:animated];
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

-(OPFQuestion *) postButtonPressed{
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
        OPFQuestion *question= [self updateDatabase];
        if(question!=nil){
            return question;
        }
        // If update was unsuccessful
        else{
            UIAlertView *emptyField = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Something terrible has happened" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [emptyField show];
        }
    }
    return nil;
}

// Update database with the data
-(OPFQuestion *) updateDatabase{
    
    NSArray *tags = [self.tagsField.text componentsSeparatedByString:@" "];
    NSMutableString *tagsString=[[NSMutableString alloc]initWithString:@""];
    
    for(NSString *s __strong in tags){
        [tagsString appendFormat:@"<%@>",s];
    }
    
    OPFQuestion *question = OPFQuestion.new;
    question.title = self.titleField.text;
    question.body = [NSString stringWithFormat:@"<p>%@</p>",self.bodyField.text];
    question.owner = OPFAppState.sharedAppState.user;
    question.tags = tags;
    
    
    NSString *title = self.titleField.text;
    NSString *body = [NSString stringWithFormat:@"<p>%@</p>",self.bodyField.text];

    OPFUser *user = OPFAppState.sharedAppState.user;
    NSString *userName = user.displayName;
    NSInteger userID = [user.identifier integerValue];
   

    [OPFUpdateQuery updateWithQuestionTitle:title Body:body Tags:tagsString ByUser:userName userID:userID];
    
    return question;
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
    
    BOOL loginReponse = [OPFAppState.sharedAppState loginWithEmailHash:email.opf_md5hash password:password persistLogin:persistFlag];
    
    if(loginReponse == YES) {
        self.loginView.hidden=YES;
    } else {
        self.wrongPasswordLabel.hidden = NO;
    }
}

@end
