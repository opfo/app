//
//  OPFDebugViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFDebugViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableViewCell *questionsViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *questionViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *userProfileViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *userProfileSearchViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *commentsViewCell;

@end
