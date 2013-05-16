//
//  UIColor+OPFAppColors.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 09-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIColor+OPFAppColors.h"
#import "UIColor+OPFHEX.h"

@implementation UIColor (OPFAppColors)

+ (instancetype)opf_defaultBackgroundColor
{
	return [UIColor opf_colorWithHexValue:0xe2e7ed];
}

@end
