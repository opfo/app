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
	OPFQuestionsSearchBarTokenStyle _style;
}

- (void)sharedTokenCollectionViewCellInit
{
	_tokenView = [[OPFQuestionsSearchBarTokenView alloc] initWithStyle:_style];
	_tokenView.layer.shadowColor = UIColor.blackColor.CGColor;
	_tokenView.layer.shadowOffset = CGSizeMake(0.f, 1.f);
	_tokenView.layer.shadowOpacity = .40f;
	_tokenView.layer.shadowRadius = 2.f;
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

@end
