//
//  OPFQuestionsSearchBarInputView.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 01-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsSearchBarInputView.h"
#import "OPFQuestionsSearchBarInputButtonsView.h"
#import "UIView+OPFViewLoading.h"
#import <SSToolkit/SSLineView.h>
#import <QuartzCore/QuartzCore.h>


@implementation OPFQuestionsSearchBarInputView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) [self sharedQuestionsSearchBarInputViewInit];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) [self sharedQuestionsSearchBarInputViewInit];
	return self;
}

- (void)sharedQuestionsSearchBarInputViewInit
{
	_state = kOPFQuestionsSearchBarInputStateButtons;
	
	UIColor *searchBarInputStartColor = [UIColor colorWithHue:205.f/360.f saturation:5.f/100.f brightness:89.f/100.f alpha:1.f];
	UIColor *searchBarInputEndColor = [UIColor colorWithHue:203.f/360.f saturation:9.f/100.f brightness:77.f/100.f alpha:1.f];
	self.colors = @[ searchBarInputStartColor, searchBarInputEndColor ];
	self.frame = CGRectMake(0.f, 0.f, 0.f, 44.f);
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.layer.shadowColor = UIColor.blackColor.CGColor;
	self.layer.shadowOffset = CGSizeMake(0.f, -2.f);
	self.layer.shadowOpacity = .1f;
	self.layer.shadowRadius = 2.f;
	
	OPFQuestionsSearchBarInputButtonsView *searchBarInputButtonsView = [OPFQuestionsSearchBarInputButtonsView opf_loadViewFromNIB];
	_buttonsView = searchBarInputButtonsView;
	
	UICollectionViewFlowLayout *completionsViewLayout = [UICollectionViewFlowLayout new];
	completionsViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	completionsViewLayout.minimumInteritemSpacing = 10.f;
	completionsViewLayout.sectionInset = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
	
	UICollectionView *searchBarInputCompletionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 44.f) collectionViewLayout:completionsViewLayout];
	searchBarInputCompletionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	searchBarInputCompletionView.backgroundColor = [UIColor clearColor];
	searchBarInputCompletionView.showsHorizontalScrollIndicator = NO;
	searchBarInputCompletionView.showsVerticalScrollIndicator = NO;
	_completionsView = searchBarInputCompletionView;
	
	SSLineView *tokenTopBorderView = [[SSLineView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 2.f)];
	tokenTopBorderView.lineColor = [UIColor colorWithHue:206.f/360.f saturation:19.f/100.f brightness:65.f/100.f alpha:1.f];
	tokenTopBorderView.insetColor = [UIColor colorWithHue:206.f/360.f saturation:2.f/100.f brightness:100.f/100.f alpha:1.f];
	tokenTopBorderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self addSubview:searchBarInputCompletionView];
	[self addSubview:searchBarInputButtonsView];
	[self addSubview:tokenTopBorderView];
}

- (void)layoutSubviews
{
	CGRect frame = self.frame;
	CGFloat width = CGRectGetWidth(frame);
	
	CGRect buttonsFrame = self.buttonsView.frame;
	buttonsFrame.size.width = frame.size.width;
	buttonsFrame.origin.x = (self.state == kOPFQuestionsSearchBarInputStateButtons ? 0.f : -width);
	self.buttonsView.frame = buttonsFrame;
	
	CGRect completionsFrame = self.completionsView.frame;
	completionsFrame.size.width = frame.size.width;
	completionsFrame.origin.x = (self.state == kOPFQuestionsSearchBarInputStateCompletions ? 0.f : width);
	self.completionsView.frame = completionsFrame;
}


@end
