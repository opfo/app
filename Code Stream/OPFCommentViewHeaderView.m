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

static NSString *const NoCountInformationPlaceholder = @"0";

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
    self.timeFormatter = [NSDateFormatter new];
    
    [self.dateFormatter setDateFormat:@"dd.MM.yyyy"];
    [self.timeFormatter setDateFormat:@"HH:mm"];
}

- (void)setModelValuesInView
{
    self.postTitle.text = self.postModel.title;
    self.postUserName.text = self.postModel.owner.displayName;
    self.postDate.text = [self.dateFormatter stringFromDate:self.postModel.creationDate];
    self.postTime.text = [self.timeFormatter stringFromDate:self.postModel.creationDate];
    self.postCommentCount.text = (! [self.postModel.commentCount stringValue] == 0 ) ? [self.postModel.commentCount stringValue] : NoCountInformationPlaceholder;

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
