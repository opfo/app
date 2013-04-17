//
//  OPFCommentViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFCommentViewController : UITableViewCell

@property(nonatomic, weak) IBOutlet UITextView *commentBody;
@property(nonatomic, weak) IBOutlet UILabel *commentUserName;
@property(nonatomic, weak) IBOutlet UILabel *commentDate;
@property(nonatomic, weak) IBOutlet UILabel *commentTime;
@property(nonatomic, weak) IBOutlet UIButton *commentUpVote;
@property(nonatomic, weak) IBOutlet UIImageView *userAvatar;

@end
