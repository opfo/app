//
//  OPFProfileViewCell.h
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFProfileSearchViewController, OPFUser, AGMedallionView;

@interface OPFProfileViewCell : UITableViewCell

@property(nonatomic, weak) OPFProfileSearchViewController *profilesViewController;

@property(nonatomic, strong) OPFUser *userModel;

@property(weak, nonatomic) IBOutlet UILabel *userName;

- (void)setModelValuesInView;
- (void)setupFormatters;

@end
