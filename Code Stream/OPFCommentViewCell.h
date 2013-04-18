//
//  OPFCommentViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFCommentsViewController;

@interface OPFCommentViewCell : UITableViewCell

@property(nonatomic, weak) OPFCommentsViewController *commentsViewController;

@property(nonatomic, weak) IBOutlet UITextView *commentBody;
@property(nonatomic, weak) IBOutlet UILabel *commentUserName;
@property(nonatomic, weak) IBOutlet UILabel *commentDate;
@property(nonatomic, weak) IBOutlet UILabel *commentTime;
@property(nonatomic, weak) IBOutlet UIButton *commentVoteUp;
@property(nonatomic, weak) IBOutlet UIImageView *userAvatar;

@property(nonatomic, strong) NSObject *commentModel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDateFormatter *timeFormatter;

- (void)setModelValuesInView;
- (void)setupDateformatters;

@end