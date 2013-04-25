//
//  OPFUserProfileViewController.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-04-25.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFUserProfileViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *userDisplayName;
@property (weak, nonatomic) IBOutlet UITextView *userAboutMe;
@property (weak, nonatomic) IBOutlet UILabel *userLocation;
@property (weak, nonatomic) IBOutlet UILabel *userReputation;
@property (weak, nonatomic) IBOutlet UILabel *userCreationDate;
@property (weak, nonatomic) IBOutlet UITableViewCell *userLastAccess;

@end
