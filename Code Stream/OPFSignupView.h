//
//  OPFSignupView.h
//  Code Stream
//
//  Created by Tobias Deekens on 02.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFUser;

@interface OPFSignupView : UITableView

@property (weak, nonatomic) IBOutlet UITableViewCell *eMail;
@property (weak, nonatomic) IBOutlet UITableViewCell *password;
@property (weak, nonatomic) IBOutlet UITableViewCell *repeatedPassword;
@property (weak, nonatomic) IBOutlet UITableViewCell *username;
@property (weak, nonatomic) IBOutlet UITableViewCell *age;
@property (weak, nonatomic) IBOutlet UITableViewCell *location;
@property (weak, nonatomic) IBOutlet UITableViewCell *website;
@property (weak, nonatomic) IBOutlet UITableViewCell *bio;

- (BOOL)validateSignup;
- (OPFUser *)deserializeSignup;

@end
