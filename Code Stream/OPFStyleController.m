//
//  OPFStyleController.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 27-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFStyleController.h"
#import "UIFont+OPFAppFonts.h"


@implementation OPFStyleController

+ (void)applyStyle
{
	[self applySearchBarStyle];
	[self applyFontStyle];
}

+ (void)applySearchBarStyle
{
	[[UISearchBar appearance] setTintColor:[UIColor colorWithHue:203.f/360.f saturation:9.f/100.f brightness:77/100.f alpha:1.f]];
	[[UISearchBar appearance] setSearchTextPositionAdjustment:UIOffsetMake(0.f, 1.f)];
}

+ (void)applyFontStyle
{
	UIFont *regularFont = [UIFont opf_appFontOfSize:0.f];
	UIFont *boldFont = [UIFont opf_boldAppFontOfSize:0.f];
	
	[UIBarButtonItem.appearance setTitleTextAttributes:@{ UITextAttributeFont: boldFont } forState:0];
	[UINavigationBar.appearance setTitleTextAttributes:@{ UITextAttributeFont: boldFont }];
	
	// Search bars
	[[UITextField appearanceWhenContainedIn:UISearchBar.class , nil] setFont:[regularFont fontWithSize:UIFont.systemFontSize]];
}

@end
