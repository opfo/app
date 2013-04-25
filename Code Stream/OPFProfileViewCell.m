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

@interface OPFProfileViewCell()

@property(nonatomic, strong) OPFScoreNumberFormatter *scoreFormatter;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation OPFProfileViewCell

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
}

- (void)setModelValuesInView
{
    self.userName.text = self.userModel.displayName;
    self.userLocation.text = self.userModel.location;
    self.userWebsite.text = (! [[self.userModel.websiteUrl absoluteString] isEqualToString:@"NULL"]) ? [self.userModel.websiteUrl absoluteString] : @"";
    self.userReputation.text = [self.scoreFormatter stringFromScore:[self.userModel.reputation integerValue]];
    self.userVotesUp.text = [self.scoreFormatter stringFromScore:[self.userModel.upVotes integerValue]];
    self.userVotesDown.text = [self.scoreFormatter stringFromScore:[self.userModel.downVotes integerValue]];
        
    //self.userAvatar;
}

- (void)setupFormatters
{
    self.dateFormatter = [NSDateFormatter new];
    [self.dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    self.scoreFormatter = [OPFScoreNumberFormatter new];
}
@end
