//
//  OPFBarGradientView.m
//  Code Stream
//
//  Created by Tobias Deekens on 16.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFBarGradientView.h"
#import <SSLineView.h>
#import <QuartzCore/QuartzCore.h>

@interface OPFBarGradientView (/*Private*/)

@property(strong, nonatomic) SSLineView *topBorderView;
@property(strong, nonatomic) SSLineView *bottomBorderView;

@end

@implementation OPFBarGradientView

static OPFBarGradientView *init(OPFBarGradientView *self) {
    if (self) {
        self->_shouldDrawBottomBorder = YES;
        self->_shouldDrawTopBorder = YES;
        
        UIColor *startColor = [UIColor colorWithHue:205.f/360.f saturation:5.f/100.f brightness:89.f/100.f alpha:1.f];
        UIColor *endColor = [UIColor colorWithHue:203.f/360.f saturation:9.f/100.f brightness:77.f/100.f alpha:1.f];
        self.colors = @[ startColor, endColor ];
        self.frame = CGRectMake(0.f, 0.f, 0.f, 44.f);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, -2.f);
        self.layer.shadowOpacity = .1f;
        self.layer.shadowRadius = 2.f;
        
        SSLineView *topBorderView = [[SSLineView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 2.f)];
        topBorderView.lineColor = [UIColor colorWithHue:206.f/360.f saturation:19.f/100.f brightness:65.f/100.f alpha:1.f];
        topBorderView.insetColor = [UIColor colorWithHue:206.f/360.f saturation:2.f/100.f brightness:100.f/100.f alpha:.6f];
        topBorderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self->_topBorderView = topBorderView;
        [self addSubview:topBorderView];
        
        SSLineView *bottomBorderView = [[SSLineView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 1.f)];
        bottomBorderView.lineColor = [UIColor colorWithHue:206.f/360.f saturation:19.f/100.f brightness:65.f/100.f alpha:1.f];
        bottomBorderView.insetColor = nil;
        bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self->_bottomBorderView = bottomBorderView;
        [self addSubview:bottomBorderView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = init(self);
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self = init(self);
    return self;
}

- (void)setShouldDrawBottomBorder:(BOOL)shouldDrawBottomBorder
{
    if (_shouldDrawBottomBorder != shouldDrawBottomBorder) {
        _shouldDrawBottomBorder = shouldDrawBottomBorder;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateBorders];
        });
    }
}

- (void)setShouldDrawTopBorder:(BOOL)shouldDrawTopBorder
{
    if (_shouldDrawTopBorder != shouldDrawTopBorder) {
        _shouldDrawTopBorder = shouldDrawTopBorder;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateBorders];
        });
    }
}

- (void)updateBorders
{
    if (self.shouldDrawTopBorder == NO) {
        [self.topBorderView removeFromSuperview];
    } else if (self.topBorderView.superview == nil) {
        [self addSubview:self.topBorderView];
    }
    
    if (self.shouldDrawBottomBorder == NO) {
        [self.bottomBorderView removeFromSuperview];
    } else if (self.bottomBorderView.superview == nil) {
        [self addSubview:self.bottomBorderView];
    }
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect topBorderViewFrame = self.topBorderView.frame;
	topBorderViewFrame.size.width = CGRectGetWidth(self.bounds);
	self.topBorderView.frame = topBorderViewFrame;
    
    CGRect bottomBorderViewFrame = self.bottomBorderView.frame;
	bottomBorderViewFrame.size.width = CGRectGetWidth(self.bounds);
    bottomBorderViewFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(bottomBorderViewFrame);
	self.bottomBorderView.frame = bottomBorderViewFrame;
}

@end
