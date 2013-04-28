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
#import "UIImageView+KHGravatar.h"
#import "UIImageView+AFNetworking.h"

@interface OPFCommentViewHeaderView()

- (void)loadUserGravatar;

@end

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
    self.postCommentCount.text = [NSString stringWithFormat:@"%@", self.postModel.commentCount];
    [self loadUserGravatar];
}

- (void)loadUserGravatar
{
    __weak OPFCommentViewHeaderView *weakSelf = self;
    
    [self.userAvatar setImageWithGravatarEmailHash:self.postModel.owner.emailHash placeholderImage:weakSelf.userAvatar.image defaultImageType:KHGravatarDefaultImageMysteryMan rating:KHGravatarRatingX
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.userAvatar.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 
        }];
}

@end
