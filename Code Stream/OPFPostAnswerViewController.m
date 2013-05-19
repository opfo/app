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
#import "OPFDateFormatter.h"
#import "OPFDBInsertionIdentifier.h"
#import "NSString+OPFStripCharacters.h"

@interface OPFPostAnswerViewController ()

@end

@implementation OPFPostAnswerViewController
@synthesize delegate;

- (void)awakeFromNib
{
    [super awakeFromNib];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(void) viewDidLoad{
    // Configure navigationbar
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView)];
    
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

- (void)postButtonPressed
{
    
    // Check that the required fields are not empty
    if([self.answerBody.text isEqualToString:@""]) {
        self.answerBodyWarning.text = @"Title is missing";
        self.answerBodyWarning.textColor = [UIColor redColor];
        self.answerBodyWarning.hidden = NO;
    }
    else{
        // If update was successful; show an UIAlert, get the answer from db and put it into the answerview
        if([self updateDatabase]){
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
- (BOOL)updateDatabase
{
    int id = [OPFDBInsertionIdentifier getNextPostId];
    
    // Current date
    NSString *date = [OPFDateFormatter currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    OPFUser *user = OPFAppState.sharedAppState.user;
    NSInteger userID = [user.identifier integerValue];
    
    // Query to the SO db
    NSArray* args = @[@(id),@2, @(self.parentQuestion), date, @0, @0, self.answerBody.text, @(userID), date, @0];
    NSArray* col = @[@"id", @"post_type_id", @"parent_id", @"creation_date", @"score", @"view_count", @"body", @"owner_user_id", @"last_activity_date", @"comment_count"];
    BOOL succeeded = [OPFUpdateQuery insertInto:@"posts" forColumns:col values:args auxiliaryDB:NO];
    
    
    // Query to the auxiliary db so it will be in sync with the SO db
    args = @[ @(self.parentQuestion), self.answerBody.text.opf_stringByStrippingHTML ];
    col = @[@"object_id", @"aux_index_string"];
    BOOL auxSucceeded = [OPFUpdateQuery insertInto:@"posts_index" forColumns:col values:args auxiliaryDB:YES];
    
    return (succeeded && auxSucceeded);
}

// Go to previous view if user press cancel
- (void)cancelView
{
	[self.navigationController popViewControllerAnimated:YES];
}


@end
