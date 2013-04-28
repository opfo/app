//
//  OPFUserProfileViewController.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-04-25.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFUser.h"

@interface OPFUserProfileViewController : UITableViewController

+ (instancetype)newFromStoryboard;

@property (strong, nonatomic) OPFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *userDisplayName;
@property (weak, nonatomic) IBOutlet UITextView *userAboutMe;
@property (weak, nonatomic) IBOutlet UILabel *userLocation;
@property (weak, nonatomic) IBOutlet UILabel *userReputation;
@property (weak, nonatomic) IBOutlet UILabel *userCreationDate;
@property (weak, nonatomic) IBOutlet UILabel *userLastAccess;
@property (weak, nonatomic) IBOutlet UILabel *userAge;
@property (weak, nonatomic) IBOutlet UILabel *userWebsite;

@end
