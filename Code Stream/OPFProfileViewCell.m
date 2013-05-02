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
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setModelValuesInView
{
    self.userName.text = self.userModel.displayName;
}

- (void)setupFormatters
{
    self.dateFormatter = [NSDateFormatter new];
    [self.dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    self.scoreFormatter = [OPFScoreNumberFormatter new];
}

@end
