//
//  UIColor+OPFHEX.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIColor+OPFHEX.h"

@implementation UIColor (OPFHEX)

#define OPFHEXUIColorFromRGB(rgbValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.f green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.f blue:((CGFloat)(rgbValue & 0xFF))/255.f alpha:1.f]

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
