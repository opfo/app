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

- (void) configureView{
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
    NSLog(@"Button pressed");
    if([self.answerBody.text isEqualToString:@""]){
        self.answerBodyWarning.text = @"Title is missing";
        self.answerBodyWarning.textColor = [UIColor redColor];
        self.answerBodyWarning.hidden = NO;
    }
    else{
        if([self updateDatabase]){
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your answer has been posted." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [success show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            UIAlertView *emptyField = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something terrible has happened" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [emptyField show];
        }
        
    }
}

-(BOOL) updateDatabase{
    OPFUser *user = [OPFAppState userModel];
    NSString *userName = user.displayName;
    NSInteger userID = [user.identifier integerValue];
    
    return [OPFUpdateQuery updateWithAnswerText:self.answerBody.text ByUser:userName UserID:userID ParentQuestion:self.parentQuestion];
}

-(void) cancelView{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
