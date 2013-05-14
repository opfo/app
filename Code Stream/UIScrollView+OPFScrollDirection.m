//
//  UIScrollView+OPFScrollDirection.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 07-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIScrollView+OPFScrollDirection.h"
#import <BlocksKit.h>


static const void *kOPFUIScrollViewDirectionContentOffsetXKey;
static const void *kOPFUIScrollViewDirectionContentOffsetYKey;

@implementation UIScrollView (OPFScrollDirection)

- (OPFUIScrollViewDirection)opf_scrollViewScrollingDirection
{
	return [self.class opf_scrollViewScrollingDirection:self];
}

+ (OPFUIScrollViewDirection)opf_scrollViewScrollingDirection:(UIScrollView *)scrollView
{
	OPFUIScrollViewDirection direction = kOPFUIScrollViewDirectionNone;
	NSNumber *oldContentOffsetXNumber = [scrollView associatedValueForKey:kOPFUIScrollViewDirectionContentOffsetXKey];
	NSNumber *oldContentOffsetYNumber = [scrollView associatedValueForKey:kOPFUIScrollViewDirectionContentOffsetYKey];
	CGFloat newContentOffsetX = scrollView.contentOffset.x;
	CGFloat newContentOffsetY = scrollView.contentOffset.y;
	
	if (oldContentOffsetXNumber != nil) {
		double oldContentOffsetX = oldContentOffsetXNumber.doubleValue;
		if (oldContentOffsetX > newContentOffsetX) {
			direction += kOPFUIScrollViewDirectionRight;
		} else if (oldContentOffsetX < newContentOffsetX) {
			direction += kOPFUIScrollViewDirectionLeft;
		}
	}
		
	if (oldContentOffsetYNumber != nil) {
		double oldContentOffsetY = oldContentOffsetYNumber.doubleValue;
		if (oldContentOffsetY > newContentOffsetY) {
			direction += kOPFUIScrollViewDirectionUp;
		} else if (oldContentOffsetY < newContentOffsetY) {
			direction += kOPFUIScrollViewDirectionDown;
		}
	}
	
	[scrollView associateValue:@(newContentOffsetX) withKey:kOPFUIScrollViewDirectionContentOffsetXKey];
	[scrollView associateValue:@(newContentOffsetY) withKey:kOPFUIScrollViewDirectionContentOffsetYKey];
	
	return direction;
}

@end
