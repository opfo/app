//
//  OPFCommentViewHeader.m
//  Code Stream
//
//  Created by Tobias Deekens on 17.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFCommentViewHeaderView.h"
#import "UIView+OPFViewLoading.h"
#import "OPFPost.h"

@implementation OPFCommentViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [self.class opf_loadViewFromNIB];
        
    return self;
}

- (void)setupDateformatters
{
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter = [NSDateFormatter new];
    
    [self.dateFormatter setDateFormat:@"dd.MM.yyyy"];
    [self.timeFormatter setDateFormat:@"HH:mm"];
}

- (void)setModelValuesInView
{
    self.postTitle.text = self.postModel.title;
    self.postUserName.text = self.postModel.owner.displayName;
    self.postDate.text = [self.dateFormatter stringFromDate:self.postModel.lastEditDate];
    self.postTime.text = [self.timeFormatter stringFromDate:self.postModel.lastEditDate];
    self.postVoteCount.text = [self.postModel.score stringValue];
    //self.userAvatar = self.postModel
}

@end
