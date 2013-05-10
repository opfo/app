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
    [self.postButton addTarget:self action:@selector(postButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
    
    
    NSLog(@"Configured");
}

-(void) postButtonPressed{
    NSLog(@"Button pressed");
    if([self.titleField.text isEqualToString:@""] || [self.bodyField.text isEqualToString:@""] || [self.tagsField.text isEqualToString:@""]){
        UIAlertView *emptyField = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Please fill in empty fields" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [emptyField show];
    }
    else{
        if([self updateDatabase]){
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
    NSString *tags = self.tagsField.text;
    
    OPFUser *user = [OPFAppState userModel];
    NSString *userName = user.displayName;
    NSInteger userID = [user.identifier integerValue];
    
    
    return [OPFUpdateQuery updateWithQuestionTitle:title Body:body Tags:tags ByUser:userName userID:userID];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField==self.titleField || textField==self.bodyField || textField==self.tagsField){
        [textField resignFirstResponder];
    }
    return YES;
}


@end
