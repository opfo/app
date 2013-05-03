//
//  UIColor+OPFHEX.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIColor+OPFHEX.h"

@implementation UIColor (OPFHEX)

#define OPFHEXUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

+ (instancetype)opf_colorWithHexString:(NSString *)hexString
{
	NSInteger hexValue = hexString.integerValue;
	return [self opf_colorWithHexValue:hexValue];
}

+ (instancetype)opf_colorWithHexValue:(NSInteger)hexValue
{
	NSParameterAssert(hexValue >= 0 && hexValue <= 0xFFFFFF);
	UIColor *color = OPFHEXUIColorFromRGB(hexValue);
	return color;
}

@end
