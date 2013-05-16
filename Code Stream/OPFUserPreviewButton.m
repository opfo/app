//
//  OPFUserPreviewButton.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-30.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUserPreviewButton.h"
#import "OPFUser.h"
#import "OPFScoreNumberFormatter.h"
#import "UIImageView+KHGravatar.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+OPFScalingAndResizing.h"
#import "OPFUserProfileViewController.h"
#import "UIFont+OPFAppFonts.h"

@implementation OPFUserPreviewButton {
	OPFScoreNumberFormatter *_scoreFormatter;
}

- (void)setUser:(OPFUser *)user {
	_user = user;
	
	self.displayNameLabel.text = user.displayName;
	self.scoreLabel.text = [_scoreFormatter stringFromScore:user.reputation.integerValue];
	[self.userAvatar setImageWithGravatarEmailHash:user.emailHash placeholderImage:self.userAvatar.image defaultImageType:KHGravatarDefaultImageMysteryMan rating:KHGravatarRatingX];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initSubviews];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initSubviews];
	}
	return self;
}

-(void)initSubviews
{
	_scoreFormatter = OPFScoreNumberFormatter.new;
	
	_iconAlign = kOPFIconAlignLeft;
	
	_userAvatar = [UIImageView new];
	_displayNameLabel = [UILabel new];
	_scoreLabel = [UILabel new];
	
	_displayNameLabel.textAlignment = NSTextAlignmentLeft;
	_displayNameLabel.textColor = [UIColor colorWithWhite:0.25 alpha:1.000];
	_displayNameLabel.highlightedTextColor = UIColor.whiteColor;
	_displayNameLabel.font = [UIFont opf_appFontOfSize:15.f];
	_displayNameLabel.backgroundColor = UIColor.clearColor;
	_scoreLabel.textAlignment = NSTextAlignmentLeft;
	_scoreLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
	_scoreLabel.highlightedTextColor = UIColor.whiteColor;
	_scoreLabel.font = [UIFont opf_appFontOfSize:15.f];
	_scoreLabel.backgroundColor = UIColor.clearColor;
	
	[self addSubview:self.userAvatar];
	[self addSubview:self.displayNameLabel];
	[self addSubview:self.scoreLabel];
	
	[self setTitle:@"" forState:0];
	[self setBackgroundImage:[UIImage imageNamed:@"user-preview-background-selected"] forState:UIControlStateHighlighted];
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	
	self.displayNameLabel.highlighted = highlighted;
	self.scoreLabel.highlighted = highlighted;
}

-(void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect frame = self.frame;
	CGRect displayName, score, image;
	
	
	score.origin.y = frame.size.height / 2 - 2;
	score.size.width = frame.size.width - frame.size.height;
	score.size.height = frame.size.height / 2;
	
	displayName.origin.y = 0.0;
	displayName.size.height = frame.size.height / 2;
	displayName.size.width = frame.size.width - frame.size.height;
	
	image.origin.y = 0.0;
	image.size.width = frame.size.height;
	image.size.height = frame.size.height;
	
	switch (self.iconAlign) {
		case kOPFIconAlignLeft:
			image.origin.x = 0.0;
			displayName.origin.x = frame.size.height;
			score.origin.x = frame.size.height;
			break;
		case kOPFIconAlignRight:
			image.origin.x = frame.size.width-frame.size.height;
			displayName.origin.x = -10.0;
			score.origin.x = -10.0;
			
			self.scoreLabel.textAlignment = NSTextAlignmentRight;
			self.displayNameLabel.textAlignment = NSTextAlignmentRight;
			break;
		case kOPFIconAlignNone: {
			image = CGRectZero;
			displayName.origin.x = 0.0;
			score.origin.x = 0.0;
			
			displayName.size.width = frame.size.width;
			score.size.width = frame.size.width;
		}
		default:
			break;
	}
	
	self.displayNameLabel.frame = displayName;
	self.scoreLabel.frame = score;
	self.userAvatar.frame = image;
}

- (void)setIconAlign:(OPFIconAlign)iconAlign
{
	if (_iconAlign != iconAlign) {
		_iconAlign = iconAlign;
		
		if (iconAlign == kOPFIconAlignRight) {
			self.displayNameLabel.textAlignment = NSTextAlignmentRight;
			self.scoreLabel.textAlignment = NSTextAlignmentRight;
		} else {
			self.displayNameLabel.textAlignment = NSTextAlignmentLeft;
			self.scoreLabel.textAlignment = NSTextAlignmentLeft;
		}
		
		[self setNeedsLayout];
		[self setNeedsDisplay];
	}
}


@end
