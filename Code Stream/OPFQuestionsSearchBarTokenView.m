//
//  OPFTagsSearchBarTokenView.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsSearchBarTokenView.h"
#import "UIColor+OPFHEX.h"
#import <QuartzCore/QuartzCore.h>


@interface OPFQuestionsSearchBarTokenView (/*Private*/)

- (void)setNeedsUpdateGradient;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end


@implementation OPFQuestionsSearchBarTokenView {
	BOOL _needsToUpdateGradient;
}

const CGFloat kOPFTokenTextFontSize = 14.f;

const CGFloat kOPFTokenHeight = 24.f;
const CGFloat kOPFTokenPaddingLeft = 6.f;
const CGFloat kOPFTokenPaddingRight = kOPFTokenPaddingLeft;
const CGFloat kOPFTokenPaddingTop = (NSInteger)(kOPFTokenHeight - kOPFTokenTextFontSize) / 4;


#pragma mark - Object Lifecycle
- (id)init
{
	self = [self initWithStyle:kOPFQuestionsSearchBarTokenStyleDefault];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self) {
		[self sharedQuestionsSearchBarTokenViewInit];
		[self setUpQuestionsSearchBarStyle:kOPFQuestionsSearchBarTokenStyleDefault];
	}
    return self;
}

- (instancetype)initWithStyle:(OPFQuestionsSearchBarTokenStyle)style
{
	self = [super init];
	if (self) {
		[self sharedQuestionsSearchBarTokenViewInit];
		[self setUpQuestionsSearchBarStyle:style];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self sharedQuestionsSearchBarTokenViewInit];
		[self setUpQuestionsSearchBarStyle:kOPFQuestionsSearchBarTokenStyleDefault];
	}
    return self;
}

- (void)sharedQuestionsSearchBarTokenViewInit
{
	self.frame = CGRectMake(0.f, 0.f, kOPFTokenPaddingLeft + kOPFTokenPaddingRight, kOPFTokenHeight);
	self.autoresizingMask = UIViewAutoresizingNone;
	self.backgroundColor = UIColor.clearColor;
	
	UIScreen *screen = self.window.screen ?: UIScreen.mainScreen;
	_borderWidth = 1.f / screen.scale;
	
	_gradientLayer = CAGradientLayer.layer;
	_gradientLayer.borderWidth = _borderWidth;
	[self.layer insertSublayer:_gradientLayer atIndex:0];
	
	_textLabel = [[UILabel alloc] init];
	_textLabel.textAlignment = NSTextAlignmentCenter;
	_textLabel.textColor = UIColor.blackColor;
	_textLabel.backgroundColor = UIColor.clearColor;
//	_textLabel.shadowColor = [UIColor.blackColor colorWithAlphaComponent:.5f];
//	_textLabel.shadowOffset = CGSizeMake(0.f, -1.f);
	_textLabel.font = [UIFont systemFontOfSize:kOPFTokenTextFontSize];
	[self addSubview:_textLabel];
}


#pragma mark - Style
- (void)setUpTagStyleDefaults
{
	self.backgroundStartColor = [UIColor opf_colorWithHexValue:0xdce6f8];
	self.backgroundEndColor = [UIColor opf_colorWithHexValue:0xbdcff1];
	self.borderColor = [UIColor opf_colorWithHexValue:0xa3bcea];
}

- (void)setUpUserStyleDefaults
{
	self.backgroundStartColor = [UIColor opf_colorWithHexValue:0xceeccb];
	self.backgroundEndColor = [UIColor opf_colorWithHexValue:0xa1e29a];
	self.borderColor = [UIColor opf_colorWithHexValue:0x8fb58b];
}

- (void)setUpQuestionsSearchBarStyle:(OPFQuestionsSearchBarTokenStyle)style
{
	switch (style) {
		case kOPFQuestionsSearchBarTokenStyleTag: [self setUpTagStyleDefaults]; break;
		case kOPFQuestionsSearchBarTokenStyleUser: [self setUpUserStyleDefaults]; break;
		default:
			ZAssert(NO, @"Unknown token style, got '%d'", style);
			break;
	}
}


#pragma mark - Background
- (void)updateBackgroundGradient
{
	UIColor *startColor = self.backgroundStartColor ?: self.backgroundColor;
	UIColor *endColor = self.backgroundEndColor ?: self.backgroundColor;
	self.gradientLayer.colors = @[ (id)startColor.CGColor, (id)endColor.CGColor ];
	
	self.gradientLayer.borderColor = self.borderColor.CGColor;
	self.gradientLayer.borderWidth = self.borderWidth;
	
	[self setNeedsDisplay];
}

- (void)setNeedsUpdateGradient
{
	if (_needsToUpdateGradient == NO) {
		[NSOperationQueue.mainQueue addOperationWithBlock:^{
			[self updateBackgroundGradient];
			_needsToUpdateGradient = YES;
		}];
	}
}


#pragma mark - Layout
- (CGSize)sizeThatFits:(CGSize)maxSize
{
	CGSize textSize = [self.textLabel sizeThatFits:maxSize];
	CGSize size = CGSizeMake(kOPFTokenPaddingLeft + textSize.width + kOPFTokenPaddingRight, kOPFTokenHeight);
	return size;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.textLabel sizeToFit];
	CGRect textFrame = self.textLabel.frame;
	textFrame.origin.y = kOPFTokenPaddingTop;
	textFrame.origin.x = kOPFTokenPaddingLeft;
	self.textLabel.frame = textFrame;
	
	CGRect selfFrame = self.frame;
	selfFrame.size.width = kOPFTokenPaddingLeft + self.textLabel.frame.size.width + kOPFTokenPaddingRight;
	self.frame = selfFrame;
	
	self.gradientLayer.frame = self.frame;
	self.gradientLayer.cornerRadius = CGRectGetHeight(self.frame) / 2.f;
}


#pragma mark - Custom setters
- (void)setBackgroundStartColor:(UIColor *)backgroundStartColor
{
	if (_backgroundStartColor != backgroundStartColor) {
		_backgroundStartColor = backgroundStartColor;
		
		[self setNeedsUpdateGradient];
	}
}

- (void)setBackgroundEndColor:(UIColor *)backgroundEndColor
{
	if (_backgroundEndColor != backgroundEndColor) {
		_backgroundEndColor = backgroundEndColor;
		
		[self setNeedsUpdateGradient];
	}
}

- (void)setBorderColor:(UIColor *)borderColor
{
	if (_borderColor != borderColor) {
		_borderColor = borderColor;
		
		[self setNeedsUpdateGradient];
	}
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
	if (_borderWidth != borderWidth) {
		_borderWidth = borderWidth;
		
		[self setNeedsUpdateGradient];
	}
}

- (void)setText:(NSString *)text
{
	self.textLabel.text = text;
	[self setNeedsLayout];
}

- (NSString *)text
{
	return self.textLabel.text;
}



@end
