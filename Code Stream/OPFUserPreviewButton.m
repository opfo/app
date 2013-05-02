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
	[self.userAvatar setImageWithGravatarEmailHash:user.emailHash];
}

-(void)openUserProfileView {
	OPFUserProfileViewController *userProfileViewController = OPFUserProfileViewController.newFromStoryboard;
    userProfileViewController.user = self.user;
    
    NSLog(@"Open user %@",self.user.displayName);
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
	_userAvatar = [UIImageView new];
	_displayNameLabel = [UILabel new];
	_scoreLabel = [UILabel new];
	
	_displayNameLabel.textAlignment = NSTextAlignmentRight;
	_scoreLabel.textAlignment = NSTextAlignmentRight;
	_scoreLabel.textColor = [UIColor grayColor];
	

	
	[self addSubview:self.userAvatar];
	[self addSubview:self.displayNameLabel];
	[self addSubview:self.scoreLabel];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	CGRect frame = self.frame;
	CGRect image = { .origin.x = frame.size.width-frame.size.height, .origin.y = 0.0, .size.width = frame.size.height, .size.height = frame.size.height };
	CGRect displayName = { .origin.x = 0.0, .origin.y = 0.0, .size.width = frame.size.width - frame.size.height, .size.height = frame.size.height / 2 };
	CGRect score = { .origin.x = 0.0, .origin.y = frame.size.height / 2, .size.width = frame.size.width - frame.size.height, .size.height = frame.size.height / 2 };
	
	self.displayNameLabel.frame = displayName;
	self.scoreLabel.frame = score;
	self.userAvatar.frame = image;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
