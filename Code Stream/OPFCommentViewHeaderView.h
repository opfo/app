//
//  OPFCommentViewHeader.h
//  Code Stream
//
//  Created by Tobias Deekens on 17.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFPost;

@interface OPFCommentViewHeaderView : UITableViewHeaderFooterView

@property(nonatomic, weak) IBOutlet UILabel *postTitle;
@property(nonatomic, weak) IBOutlet UILabel *postUserName;
@property(nonatomic, weak) IBOutlet UILabel *postDate;
@property(nonatomic, weak) IBOutlet UILabel *postTime;
@property(nonatomic, weak) IBOutlet UIImageView *userAvatar;
@property(nonatomic, weak) IBOutlet UILabel *postCommentCount;

@property(nonatomic, strong) OPFPost *postModel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDateFormatter *timeFormatter;

- (void)setModelValuesInView;
- (void)setupDateformatters;

@end
