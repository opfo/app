//
//  UIFont+OPFAppFonts.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 03-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kOPFStyleFontFamilyDefault;
extern NSString *const kOPFStyleFontNameDefault;
extern NSString *const kOPFStyleFontNameDefaultBold;
extern NSString *const kOPFStyleFontNameDefaultItalic;


@interface UIFont (OPFAppFonts)

+ (NSString *)opf_appFontFamilyName;

+ (instancetype)opf_appFontOfSize:(CGFloat)fontSize;
+ (instancetype)opf_boldAppFontOfSize:(CGFloat)fontSize;
+ (instancetype)opf_italicsAppFontOfSize:(CGFloat)fontSize;

@end
