//
//  UIColor+OPFColorAdjustment.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 16-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIColor+OPFColorAdjustment.h"

@implementation UIColor (OPFColorAdjustment)

#pragma mark - Modifying the Color
- (UIColor *)opf_colorWithBrightness:(CGFloat)brightness
{
	return [self opf_colorWithSaturation:-1.f brightness:brightness alpha:-1.f];
}

- (UIColor *)opf_colorWithSaturation:(CGFloat)saturation
{
	return [self opf_colorWithSaturation:saturation brightness:-1.f alpha:-1.f];
}

- (UIColor *)opf_colorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness
{
	return [self opf_colorWithSaturation:saturation brightness:brightness alpha:-1.f];
}

- (UIColor *)opf_colorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
{
	CGFloat hue = 0.f, currentSaturation = 0.f, currentBrightness = 0.f, currentAlpha = 0.f;
	BOOL couldConvertToHSB = [self getHue:&hue saturation:&currentSaturation brightness:&currentBrightness alpha:&currentAlpha];
	if (couldConvertToHSB == NO) {
		UIColor *hsbColor = self.opf_HSBColor;
		couldConvertToHSB = [hsbColor getHue:&hue saturation:&currentSaturation brightness:&currentBrightness alpha:&currentAlpha];
	}
	NSAssert(couldConvertToHSB == YES, @"The color (%@) must convertable into the HSB color space.", self);
	
	UIColor *color = nil;
	if (couldConvertToHSB == YES) {
		saturation = (saturation == -1.f ? currentSaturation : saturation);
		brightness = (brightness == -1.f ? currentBrightness : brightness);
		alpha = (alpha == -1.f ? currentAlpha : alpha);
		
		color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
	}
	
	return color;
}

- (instancetype)opf_HSBColor
{
	UIColor *color = nil;
	CGFloat alpha = 0.f;
	CGFloat white = 0.f;
	
	BOOL isWhiteColor = [self getWhite:&white alpha:&alpha];
	if (isWhiteColor) {
		color = [UIColor colorWithHue:0.f saturation:0.f brightness:white alpha:alpha];
	} else {
		CGFloat red = 0.f, green = 0.f, blue = 0.f;
		BOOL isRGB = [self getRed:&red green:&green blue:&blue alpha:&alpha];
		if (isRGB) {
			color = [UIColor opf_HSBColorWithRed:red green:green blue:blue alpha:alpha];
		}
	}
	
	return color;
}

+ (void)opf_max:(int*)max andMin:(int*)min ofArray:(float[])array
{
    *min=0;
    *max=0;
    for(int i=1; i<3; i++) {
        if(array[i] > array[*max]) { *max=i; }
        if(array[i] < array[*min]) { *min=i; }
    }
}

+ (UIColor *)opf_HSBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	CGFloat hue = 0.f;
	CGFloat saturation = 0.f;
	CGFloat brightness = 0.f;
	
    float colorArray[3];
    colorArray[0] = red;
    colorArray[1] = green;
    colorArray[2] = blue;
	
    int max = 0;
    int min = 0;
    [self opf_max:&max andMin:&min ofArray:colorArray];
	
    if(max==min) {
		hue = 0;
        saturation = 0;
        brightness = colorArray[0];
    } else {
        brightness=colorArray[max];
		saturation=(colorArray[max]-colorArray[min])/(colorArray[max]);
		
        if(max == 0) { // Red
            hue = (colorArray[1]-colorArray[2])/(colorArray[max]-colorArray[min])*60.f/360.f;
        } else if(max == 1) { // Green
            hue = (2.f + (colorArray[2]-colorArray[0])/(colorArray[max]-colorArray[min]))*60.f/360.f;
        } else { // Blue
            hue = (4.f + (colorArray[0]-colorArray[1])/(colorArray[max]-colorArray[min]))*60.f/360.f;
		}
    }
	
	UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    return color;
}

@end

