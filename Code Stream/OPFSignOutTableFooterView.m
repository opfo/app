//
//  OPFSignoutTableFooterView.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 17-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSignOutTableFooterView.h"
#import "OPFProfileContainerController.h"
#import "UIFont+OPFAppFonts.h"


const CGFloat kOPFSignOutTableFooterViewPaddingTop = 0.f;
const CGFloat kOPFSignOutTableFooterViewPaddingBottom = kOPFSignOutTableFooterViewPaddingTop;
const CGFloat kOPFSignOutTableFooterViewPaddingLeft = 10.f;
const CGFloat kOPFSignOutTableFooterViewPaddingRight = kOPFSignOutTableFooterViewPaddingLeft;

@implementation OPFSignOutTableFooterView

static OPFSignOutTableFooterView *init(OPFSignOutTableFooterView *self) {
	if (self) {
		self->_padding = UIEdgeInsetsMake(kOPFSignOutTableFooterViewPaddingTop, kOPFSignOutTableFooterViewPaddingLeft, kOPFSignOutTableFooterViewPaddingBottom, kOPFSignOutTableFooterViewPaddingRight);
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
		signOutButton.titleLabel.font = [UIFont opf_boldAppFontOfSize:20.f];
		signOutButton.frame = self.frame;
		signOutButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[signOutButton setTitle:NSLocalizedString(@"Logout", @"Logout button title") forState:UIControlStateNormal];
		[signOutButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
		[signOutButton setTitleColor:UIColor.grayColor forState:UIControlStateHighlighted];
		[signOutButton setBackgroundImage:[UIImage imageNamed:@"profile-logout"] forState:UIControlStateNormal];
		[signOutButton addTarget:nil action:@selector(userRequestsLogout:) forControlEvents:UIControlEventTouchUpInside];
		self->_signOutButton = signOutButton;
		[self addSubview:signOutButton];
	}
	return self;
}

- (id)init
{
	self = [self initWithFrame:CGRectMake(0, 0, 0, 44.f)];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	self = init(self);
	return self;
}

- (void)setPadding:(UIEdgeInsets)padding
{
	if (UIEdgeInsetsEqualToEdgeInsets(_padding, padding) == NO) {
		_padding = padding;
		[self setNeedsLayout];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	UIEdgeInsets padding = self.padding;
	
	CGRect buttonFrame = self.signOutButton.frame;
	buttonFrame.origin.x = padding.left;
	buttonFrame.origin.y = padding.top;
	buttonFrame.size.width = bounds.size.width - (padding.left + padding.right);
	self.signOutButton.frame = buttonFrame;
	
	bounds.size.height = buttonFrame.size.height + padding.top + padding.bottom;
	self.bounds = bounds;
}


@end
