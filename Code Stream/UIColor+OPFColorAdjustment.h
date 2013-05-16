//
//  UIColor+OPFColorAdjustment.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 16-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (OPFColorAdjustment)

#pragma mark - Modifying the Color
// Implementation limitation: the UIColor object which recieves these messages
// must support transformation to HSB (hue, saturation brightness).
- (UIColor *)opf_colorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha;
- (UIColor *)opf_colorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness;
- (UIColor *)opf_colorWithSaturation:(CGFloat)saturation;
- (UIColor *)opf_colorWithBrightness:(CGFloat)brightness;

@end
