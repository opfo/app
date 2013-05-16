//
//  OPFCommentViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFCommentsViewController, OPFComment, OPFSidebarView;

@interface OPFCommentViewCell : UITableViewCell

@property(nonatomic, weak) OPFCommentsViewController *commentsViewController;

@property (strong, nonatomic) IBOutlet OPFSidebarView *sidebarBackground;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentBodyHeight;
@property(weak, nonatomic) IBOutlet UITextView *commentBody;
@property(weak, nonatomic) IBOutlet UIButton *commentUserName;
@property(weak, nonatomic) IBOutlet UILabel *commentDate;
@property(weak, nonatomic) IBOutlet UILabel *commentTime;
@property (strong, nonatomic) IBOutlet UILabel *commentVoteCountSubHeader;
@property(weak, nonatomic) IBOutlet UIButton *commentVoteUp;
@property (strong, nonatomic) IBOutlet UILabel *commentVoteCount;
@property(weak, nonatomic) IBOutlet UIImageView *userAvatar;

- (IBAction)voteUpComment:(UIButton *)sender;
- (IBAction)didSelectDisplayName:(UIButton *)sender;

- (void)configureForComment:(OPFComment *)comment;

@end