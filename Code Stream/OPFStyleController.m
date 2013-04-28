//
//  OPFStyleController.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 27-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFStyleController.h"

@implementation OPFStyleController

+ (void)applyStyle
{
	[self applySearchBarStyle];
}

+ (void)applySearchBarStyle
{
	[[UISearchBar appearance] setTintColor:[UIColor colorWithHue:203.f/360.f saturation:9.f/100.f brightness:77/100.f alpha:1.f]];
}

@end
