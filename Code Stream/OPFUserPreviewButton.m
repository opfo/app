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
#import "OPFUserProfileViewController.h"

@implementation OPFUserPreviewButton

- (void)setUser:(OPFUser *)user {
	_user = user;
	
	OPFScoreNumberFormatter *format = [OPFScoreNumberFormatter new];
	
	self.displayNameLabel.text = user.displayName;
	self.scoreLabel.text = [format stringFromScore:user.reputation.integerValue];
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

-(void)initSubviews {
	
	_iconAlign = kOPFIconAlignLeft;
	
	_userAvatar = [UIImageView new];
	_displayNameLabel = [UILabel new];
	_scoreLabel = [UILabel new];
	
	_displayNameLabel.textAlignment = NSTextAlignmentLeft;
	_scoreLabel.textAlignment = NSTextAlignmentLeft;
	_scoreLabel.textColor = [UIColor grayColor];
	

	
	[self addSubview:self.userAvatar];
	[self addSubview:self.displayNameLabel];
	[self addSubview:self.scoreLabel];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect frame = self.frame;
	CGRect displayName, score, image;
	
	
	score.origin.y = frame.size.height / 2;
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
