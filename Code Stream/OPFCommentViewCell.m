//
//  OPFCommentViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFCommentViewCell.h"
#import "OPFCommentsViewController.h"

@implementation OPFCommentViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)voteUpComment:(UIButton *)sender
{
    [self.commentsViewController voteUpComment:sender];
}

- (void)setModelValuesInView
{
//    self.commentBody.text = self.commentModel.commentBody;
//    self.commentDate.text = [self.dateFormatter stringFromDate:self.commentModel.lastEditDate];
//    self.commentTime.text = [self.timeFormatter stringFromDate:self.commentModel.lastEditDate];
//    self.commentVoteUp.titleLabel.text = self.commentModel.votes;
//    self.commentUserName.text = self.commentModel.userName;
//    self.userAvatar.text = self.commentModel.userAvatar;
}

- (void)setupDateformatters
{
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter = [NSDateFormatter new];
    
    [self.dateFormatter setDateFormat:@"dd.MM.yyyy"];
    [self.timeFormatter setDateFormat:@"HH:mm"];
}

- (void)setupUserInteractionBindings
{
    [self.commentVoteUp addTarget:self action:@selector(commentVoteUp) forControlEvents:UIControlEventTouchUpInside];
}
@end
