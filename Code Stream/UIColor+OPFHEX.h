//
//  UIColor+OPFHEX.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (OPFHEX)

+ (instancetype)opf_colorWithHexString:(NSString *)hexString;
// The hex value should be between 0x000000 - 0xFFFFFF.
+ (instancetype)opf_colorWithHexValue:(NSInteger)hexValue;

@end
