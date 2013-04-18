//
//  OPFCommentViewHeader.h
//  Code Stream
//
//  Created by Tobias Deekens on 17.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFCommentViewHeaderController : UIViewController

@property(nonatomic, weak) IBOutlet UILabel *postTitle;
@property(nonatomic, weak) IBOutlet UILabel *postUserName;
@property(nonatomic, weak) IBOutlet UILabel *postDate;
@property(nonatomic, weak) IBOutlet UILabel *postTime;
@property(nonatomic, weak) IBOutlet UIImageView *userAvatar;
@property(nonatomic, weak) IBOutlet UILabel *postVoteCount;

@property(nonatomic, strong) NSObject *postModel;

- (void)setModelValuesInView;

@end
