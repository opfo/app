//
//  OPFSignupViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 02.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDataTableViewController.h"

@interface OPFSignupViewController  : StaticDataTableViewController <UITextFieldDelegate>

+ (instancetype)newFromStoryboard;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repeatedPassword;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *website;
@property (weak, nonatomic) IBOutlet UITextView *bio;

@end