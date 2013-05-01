//
//  OPFProfileViewCell.m
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFProfileViewCell.h"
#import "OPFUser.h"
#import "OPFScoreNumberFormatter.h"
#import "UIImageView+KHGravatar.h"
#import "UIImageView+AFNetworking.h"
#import "AGMedallionView.h"

@interface OPFProfileViewCell()

@property(nonatomic, strong) OPFScoreNumberFormatter *scoreFormatter;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) UIImageView *userGravatar;

- (void)setAvatarWithGravatar :(UIImage*) gravatar;
- (void)loadUserGravatar;
- (void)opfSetupView;

@end

@implementation OPFProfileViewCell

static NSString *const NotSpecifiedInformationPlaceholder = @"-";

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self opfSetupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

- (void)loadUserGravatar
{
    __weak OPFProfileViewCell *weakSelf = self;
    
    [self.userGravatar setImageWithGravatarEmailHash:self.userModel.emailHash placeholderImage:weakSelf.userGravatar.image defaultImageType:KHGravatarDefaultImageMysteryMan rating:KHGravatarRatingX
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakSelf setAvatarWithGravatar:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
}

- (void)opfSetupView
{
    self.userAvatar.image = [UIImage imageNamed:@"avatar-empty"];
    self.userAvatar.style = AGMedallionStyleSquare;
    self.userAvatar.cornerRadius = 10.0f;
    self.userAvatar.borderWidth = 0.5f;
    
    //Used for loading via AFNetworking
    self.userGravatar = [UIImageView new];
    self.userGravatar.image = self.userAvatar.image;
}

- (void)setAvatarWithGravatar :(UIImage*) gravatar
{
    self.userAvatar.image = gravatar;
    [self.userAvatar setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setModelValuesInView
{
    self.userName.text = self.userModel.displayName;
    self.userLocation.text = (! [self.userModel.location isEqualToString:@"NULL"] ) ? self.userModel.location : NotSpecifiedInformationPlaceholder;
    self.userWebsite.text = (! [[self.userModel.websiteUrl absoluteString] isEqualToString:@"NULL"] ) ? [self.userModel.websiteUrl absoluteString] : NotSpecifiedInformationPlaceholder;
    self.userReputation.text = [self.scoreFormatter stringFromScore:[self.userModel.reputation integerValue]];
    self.userVotesUp.text = [self.scoreFormatter stringFromScore:[self.userModel.upVotes integerValue]];
    self.userVotesDown.text = [self.scoreFormatter stringFromScore:[self.userModel.downVotes integerValue]];
    
    [self opfSetupView];
    [self loadUserGravatar];
}

- (void)setupFormatters
{
    self.dateFormatter = [NSDateFormatter new];
    [self.dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    self.scoreFormatter = [OPFScoreNumberFormatter new];
}
@end
