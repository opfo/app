//
//  OPFSidebarView.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 16-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSidebarView.h"
#import "UIColor+OPFColorAdjustment.h"
#import <SSGradientView.h>
#import <SSLineView.h>


@interface OPFSidebarView (/*Private*/)
@property (strong, nonatomic) SSLineView *topBorderView;
@property (strong, nonatomic) SSLineView *bottomBorderView;

@property (strong, nonatomic) SSGradientView *backgroundView;
@end

@implementation OPFSidebarView

#pragma mark -
- (void)setTintColor:(UIColor *)tintColor
{
	if (_tintColor != tintColor) {
		_tintColor = tintColor;
		dispatch_async(dispatch_get_main_queue(), ^{
			[self updateColors];
		});
	}
}

- (void)setShouldDrawBorders:(BOOL)shouldDrawBorders
{
	if (_shouldDrawBorders != shouldDrawBorders) {
		_shouldDrawBorders = shouldDrawBorders;
		dispatch_async(dispatch_get_main_queue(), ^{
			[self updateShouldDrawBorders];
		});
	}
}

- (void)updateColors
{
	UIColor *baseColor = self.tintColor;
	
	UIColor *backgroundStartColor = [baseColor opf_colorWithBrightness:.90f];
	UIColor *backgroundEndColor = [baseColor opf_colorWithBrightness:.70f];
	self.backgroundView.colors = @[ backgroundStartColor, backgroundEndColor ];
	
	[self setNeedsDisplay];
}

- (void)updateShouldDrawBorders
{
	if (self.shouldDrawBorders == NO) {
		[self.topBorderView removeFromSuperview];
		[self.bottomBorderView removeFromSuperview];
	} else {
		[self insertSubview:self.topBorderView aboveSubview:self.backgroundView];
		[self insertSubview:self.bottomBorderView aboveSubview:self.backgroundView];
	}
	
	[self setNeedsDisplay];
}


#pragma mark - Layout
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	CGFloat width = CGRectGetWidth(bounds);
	CGFloat height = CGRectGetHeight(bounds);
	
	CGRect topBorderViewFrame = self.topBorderView.frame;
	topBorderViewFrame.size.width = width;
	self.topBorderView.frame = topBorderViewFrame;
	
	CGRect bottomBorderViewFrame = self.bottomBorderView.frame;
	bottomBorderViewFrame.size.width = width;
	bottomBorderViewFrame.origin.y = CGRectGetMaxY(bounds) - CGRectGetHeight(bottomBorderViewFrame);
	self.bottomBorderView.frame = bottomBorderViewFrame;
	
	CGRect backgroundViewFrame = self.backgroundView.frame;
	backgroundViewFrame.size.height = height;
	backgroundViewFrame.size.width = width;
	self.backgroundView.frame = backgroundViewFrame;
}


#pragma mark - Init
static OPFSidebarView *sharedInit(OPFSidebarView *self) {
	if (self) {
		self->_tintColor = UIColor.grayColor;
		self->_shouldDrawBorders = YES;
		
		SSGradientView *backgroundView = SSGradientView.new;
		self->_backgroundView = backgroundView;
		[self addSubview:backgroundView];
		
		SSLineView *topBorderView = [[SSLineView alloc] initWithFrame:CGRectMake(0, 0, 0, 2.f)];
		topBorderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		topBorderView.lineColor = [UIColor colorWithWhite:0.f alpha:.5];
		topBorderView.insetColor = [UIColor colorWithWhite:1.f alpha:.35f];
		self->_topBorderView = topBorderView;
		[self addSubview:topBorderView];
		
		SSLineView *bottomBorderView = [[SSLineView alloc] initWithFrame:CGRectMake(0, 0, 0, 1.f)];
		bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		bottomBorderView.lineColor = [UIColor colorWithWhite:0.f alpha:.5];
		bottomBorderView.insetColor = nil;
		self->_bottomBorderView = bottomBorderView;
		[self addSubview:bottomBorderView];
		
		[self updateColors];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	self = sharedInit(self);
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	self = sharedInit(self);
    return self;
}

@end
