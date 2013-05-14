//
//  OPFUserProfileViewController.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-04-25.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFUser.h"
#import "StaticDataTableViewController.h"

@interface OPFUserProfileViewController : StaticDataTableViewController <UIWebViewDelegate>

+ (instancetype)newFromStoryboard;
- (NSString *)tabImageName;
- (NSString *)tabTitle;

@property (strong, nonatomic) OPFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *userVotes;
@property (weak, nonatomic) IBOutlet UILabel *views;
@property (weak, nonatomic) IBOutlet UIWebView *userBio;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;


@property (weak, nonatomic) IBOutlet UILabel *userLocation;
@property (weak, nonatomic) IBOutlet UILabel *userReputation;
@property (weak, nonatomic) IBOutlet UILabel *userCreationDate;
@property (weak, nonatomic) IBOutlet UILabel *userLastAccess;
@property (weak, nonatomic) IBOutlet UILabel *userAge;
@property (weak, nonatomic) IBOutlet UILabel *userWebsite;
@property (weak, nonatomic) IBOutlet UIButton *logOut;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoutCell;

@end
