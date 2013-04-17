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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

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
//    self.commentTime.text = self.commentModel.commentTime;
//    self.userAvatar.text = self.commentModel.userAvatar;
//    self.commentDate.text = self.commentModel.commentDate;
//    self.commentVoteUp.titleLabel.text = self.commentModel.votes;
//    self.commentUserName.text = self.commentModel.userName;
}

- (void)setupUserInteractionBindings
{
    [self.commentVoteUp addTarget:self action:@selector(commentVoteUp) forControlEvents:UIControlEventTouchUpInside];
}
@end
