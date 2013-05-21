//
//  OPFCommentViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFCommentViewCell.h"
#import "OPFCommentsViewController.h"
#import "OPFComment.h"
#import "UIImageView+KHGravatar.h"
#import "UIImageView+AFNetworking.h"
#import "UIFont+OPFAppFonts.h"
#import <QuartzCore/QuartzCore.h>
#import <SSLineView.h>
#import "UIFont+OPFAppFonts.h"
#import "OPFSidebarView.h"
#import "NSString+OPFStripCharacters.h"
#import "NSString+OPFEscapeStrings.h"

@interface OPFCommentViewCell()

@property(strong, nonatomic) NSDateFormatter *dateFormatter;
@property(strong, nonatomic) NSDateFormatter *timeFormatter;

- (void)loadUserGravatar;
- (void)setAvatarWithGravatar :(UIImage*) gravatar;

@end

@implementation OPFCommentViewCell

static CGFloat const OPFCommentTableCellOffset = 20.0f;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_dateFormatter = NSDateFormatter.new;
        [_dateFormatter setDateFormat:@"dd.MM.yyyy"];
		_timeFormatter = NSDateFormatter.new;
        [_timeFormatter setDateFormat:@"HH:mm"];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadUserGravatar
{
    __weak OPFCommentViewCell *weakSelf = self;

    [self.userAvatar setImageWithGravatarEmailHash:self.commentModel.author.emailHash placeholderImage:weakSelf.userAvatar.image defaultImageType:KHGravatarDefaultImageMysteryMan rating:KHGravatarRatingX
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakSelf setAvatarWithGravatar:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
           
    }];
}

- (void)setAvatarWithGravatar :(UIImage*) gravatar
{
    self.userAvatar.image = gravatar;
}

- (void)awakeFromNib
{
	[self applyPropertiesOnLabel:self.commentVoteCount];
	[self applyPropertiesOnLabel:self.commentVoteCountSubHeader];
}

- (void)voteUpComment:(UIButton *)sender
{
    [self.commentsViewController voteUpComment:sender];
    //TODO: Add handling for only adding once and saving it to DB   
}

- (void)didSelectDisplayName:(UIButton *)sender
{
    [self.commentsViewController didSelectDisplayName:self.commentUserName :self.commentModel.author];
}

- (void)configureForComment:(OPFComment *)comment
{
    self.commentModel = comment;
    self.commentVoteUp.comment = comment;
    
    self.commentBody.text = [self.commentModel.text.opf_stringByStrippingHTML.opf_stringByTrimmingWhitespace OPF_escapeWithScheme:OPFStripAscii];
    self.commentDate.text = [self.dateFormatter stringFromDate:self.commentModel.creationDate];
    self.commentTime.text = [self.timeFormatter stringFromDate:self.commentModel.creationDate];
    self.commentVoteCount.text =
    [NSString stringWithFormat:@"%d", [self.commentModel.score integerValue]];
    self.commentUserName.titleLabel.text = self.commentModel.author.displayName;
    
    [self loadUserGravatar];
}

- (void)applyShadowToView:(UIView *)view
{
	view.layer.shadowColor = UIColor.blackColor.CGColor;
	view.layer.shadowOffset = CGSizeMake(0, 1);
	view.layer.shadowRadius = 1;
	view.layer.shadowOpacity = .75f;
}

- (void)applyPropertiesOnLabel:(UILabel *)label
{
	[self applyShadowToView:label];
	label.textColor = UIColor.whiteColor;
}

- (void)updateConstraints
{
    [super updateConstraints];

    CGSize textSize = [self.commentBody.text sizeWithFont:[UIFont opf_appFontOfSize:14.0f] constrainedToSize:CGSizeMake(250.f, 1000.f) lineBreakMode:NSLineBreakByWordWrapping];
        
    self.commentBodyHeight.constant = textSize.height + OPFCommentTableCellOffset;
}

@end
