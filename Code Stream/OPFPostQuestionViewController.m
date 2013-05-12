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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configureView{
    
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
}

-(void) postButtonPressed{
    NSLog(@"Button pressed");
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
    if(![self.titleField.text isEqualToString:@""] && ![self.bodyField.text isEqualToString:@""]){
        if([self updateDatabase]){
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your question has been posted." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [success show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            UIAlertView *emptyField = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Something terrible has happened" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [emptyField show];
        }
        
    }
}

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
    if(textField==self.titleField || textField==self.bodyField || textField==self.tagsField){
        [textField resignFirstResponder];
    }
    return YES;
}

-(IBAction)cancelView:(id)sender{
    [UIView
     transitionWithView:self.navigationController.view
     duration:1.0
     options:UIViewAnimationOptionTransitionCurlDown
     animations:^{
         [self.navigationController
          popViewControllerAnimated:NO];
     }
     completion:NULL];
}


@end
