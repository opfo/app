//
//  OPFPostAnswerViewController.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-12.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostAnswerViewController.h"
#import "OPFAppState.h"
#import "OPFUser.h"
#import "OPFUpdateQuery.h"

@interface OPFPostAnswerViewController ()

@end

@implementation OPFPostAnswerViewController
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureView{
    // Configure navigationbar
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView)];
    
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(20, 250, 280, 44);
    
    //set the button's title
    [button setTitle:@"Post Answer" forState:UIControlStateNormal];
    
    //listen for clicks
    [button addTarget:self action:@selector(postButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self.view addSubview:button];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void) postButtonPressed{
    
    // Check that the required fields are not empty
    if([self.answerBody.text isEqualToString:@""]){
        self.answerBodyWarning.text = @"Title is missing";
        self.answerBodyWarning.textColor = [UIColor redColor];
        self.answerBodyWarning.hidden = NO;
    }
    else{
        // Update database and store the id for the post
        NSInteger lastAnswer=[self updateDatabase];
        
        // If update was successful; show an UIAlert, get the answer from db and put it into the answerview
        if(lastAnswer!=0){
            [self.delegate updateQuestionView];
        }
        else{
            // If insert was unsuccessful
            UIAlertView *emptyField = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something terrible has happened" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [emptyField show];
        }
        
    }
}

// Update database with the filled in data
-(NSInteger) updateDatabase{
    OPFUser *user = [OPFAppState userModel];
    NSString *userName = user.displayName;
    NSInteger userID = [user.identifier integerValue];
    
    return [OPFUpdateQuery updateWithAnswerText:self.answerBody.text ByUser:userName UserID:userID ParentQuestion:self.parentQuestion];
}

// Go to previous view if user press cancel
-(void) cancelView{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
