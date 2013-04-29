//
//  OPFCommentViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFCommentsViewController, OPFComment;

@interface OPFCommentViewCell : UITableViewCell

@property(nonatomic, weak) OPFCommentsViewController *commentsViewController;

@property(weak, nonatomic) IBOutlet UITextView *commentBody;
@property(weak, nonatomic) IBOutlet UIButton *commentUserName;
@property(weak, nonatomic) IBOutlet UILabel *commentDate;
@property(weak, nonatomic) IBOutlet UILabel *commentTime;
@property(weak, nonatomic) IBOutlet UIButton *commentVoteUp;
@property(weak, nonatomic) IBOutlet UIImageView *userAvatar;

@property(strong, nonatomic) OPFComment *commentModel;
@property(strong, nonatomic) NSDateFormatter *dateFormatter;
@property(strong, nonatomic) NSDateFormatter *timeFormatter;

- (IBAction)voteUpComment:(UIButton *)sender;
- (IBAction)didSelectDisplayName:(UIButton *)sender;

- (void)setModelValuesInView;
- (void)setupDateformatters;

@end