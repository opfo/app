//
//  UIFont+OPFAppFonts.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 03-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIFont+OPFAppFonts.h"

NSString *const kOPFStyleFontFamilyDefault		= @"Avenir Next";
NSString *const kOPFStyleFontNameDefault		= @"AvenirNext-Regular";
NSString *const kOPFStyleFontNameDefaultBold	= @"AvenirNext-Bold";
NSString *const kOPFStyleFontNameDefaultItalic	= @"AvenirNext-Italic";


@implementation UIFont (OPFAppFonts)

+ (NSString *)opf_appFontFamilyName
{
	return kOPFStyleFontFamilyDefault;
}

+ (instancetype)opf_appFontOfSize:(CGFloat)fontSize
{
	return [self fontWithName:kOPFStyleFontNameDefault size:fontSize];
}

+ (instancetype)opf_boldAppFontOfSize:(CGFloat)fontSize
{
	return [self fontWithName:kOPFStyleFontNameDefaultBold size:fontSize];
}

+ (instancetype)opf_italicsAppFontOfSize:(CGFloat)fontSize
{
	return [self fontWithName:kOPFStyleFontNameDefaultItalic size:fontSize];
}


@end
