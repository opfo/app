//
//  UIView+OPFViewLoading.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 17-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIView+OPFViewLoading.h"

@implementation UIView (OPFViewLoading)

+ (instancetype)opf_loadViewFromNIB
{
	__block UIView *view = nil;
	NSArray *objects = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
	NSAssert(objects, @"Could not load the NIB for %@ from the main bundle.", NSStringFromClass(self));
	[objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:self]) {
			view = obj;
			*stop = YES;
		}
	}];
	return view;
}

@end
