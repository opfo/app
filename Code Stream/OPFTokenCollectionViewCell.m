//
//  OPFTokenCollectionViewCell.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 02-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTokenCollectionViewCell.h"
#import "OPFQuestionsSearchBarTokenView.h"
#import "UIView+OPFAutoLayout.h"
#import <QuartzCore/QuartzCore.h>


@implementation OPFTokenCollectionViewCell {
	@protected
	OPFQuestionsSearchBarTokenStyle _style;
}

- (void)sharedTokenCollectionViewCellInit
{
	_shouldDrawShadow = YES;
	_tokenView = [[OPFQuestionsSearchBarTokenView alloc] initWithStyle:_style];
	[self setShadowVisible:_shouldDrawShadow];
	[self opf_addFillingAutoresizedSubview:_tokenView];
}

- (instancetype)initWithStyle:(OPFQuestionsSearchBarTokenStyle)style
{
	_style = style;
	self = [self initWithFrame:CGRectZero];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self sharedTokenCollectionViewCellInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) [self sharedTokenCollectionViewCellInit];
	return self;
}

- (void)setShouldDrawShadow:(BOOL)shouldDrawShadow
{
	if (_shouldDrawShadow != shouldDrawShadow) {
		_shouldDrawShadow = shouldDrawShadow;
		[self setShadowVisible:_shouldDrawShadow];
		[self setNeedsDisplay];
	}
}

- (void)setShadowVisible:(BOOL)visible
{
	if (visible) {
		self.tokenView.layer.shadowColor = UIColor.blackColor.CGColor;
		self.tokenView.layer.shadowOffset = CGSizeMake(0.f, 1.f);
		self.tokenView.layer.shadowOpacity = .55f;
		self.tokenView.layer.shadowRadius = 1.f;
	} else {
		self.tokenView.layer.shadowColor = nil;
		self.tokenView.layer.shadowOpacity = 0.f;
	}
}

@end

@implementation OPFTagTokenCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
	_style =kOPFQuestionsSearchBarTokenStyleTag;
	self = [super initWithFrame:frame];
	return self;
}
@end

@implementation OPFUserTokenCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
	_style =kOPFQuestionsSearchBarTokenStyleUser;
	self = [super initWithFrame:frame];
	return self;
}
@end
