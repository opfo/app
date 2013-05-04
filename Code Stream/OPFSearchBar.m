//
//  OPFSearchBar.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 04-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSearchBar.h"
#import "UIColor+OPFHEX.h"
#import "SSLineView.h"


@implementation OPFSearchBar

- (void)sharedOPFSearchBarInit
{
	SSLineView *topBorderView = [[SSLineView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 2.f)];
	topBorderView.lineColor = [UIColor opf_colorWithHexValue:0xa0adb7];
	topBorderView.insetColor = [UIColor opf_colorWithHexValue:0xe3e9ed];
	topBorderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_topBorderView = topBorderView;
	[self addSubview:_topBorderView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self sharedOPFSearchBarInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) [self sharedOPFSearchBarInit];
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect topBorderViewFrame = self.topBorderView.frame;
	topBorderViewFrame.size.width = CGRectGetWidth(self.bounds);
	self.topBorderView.frame = topBorderViewFrame;
}


@end
