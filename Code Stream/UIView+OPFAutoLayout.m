//
//  UIView+OPFAutoLayout.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIView+OPFAutoLayout.h"

@implementation UIView (OPFAutoLayout)

- (void)opf_addAutoresizedSubview:(UIView *)aView
{
	if (aView != nil) {
		[aView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self addSubview:aView];
		
		NSDictionary *views = NSDictionaryOfVariableBindings(aView);
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[aView]|" options:0 metrics:nil views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aView]|" options:0 metrics:nil views:views]];
	}
}

- (void)opf_removeAllSubviews
{
	__block CGRect dirtyRect = CGRectZero;
	
	[self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
		dirtyRect = CGRectUnion(dirtyRect, subview.bounds);
		[subview removeFromSuperview];
	}];
	
	[self setNeedsDisplayInRect:dirtyRect];
}

@end
