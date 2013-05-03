//
//  OPFTagsSearchBarTokenView.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSInteger {
	kOPFQuestionsSearchBarTokenStyleTag,
	kOPFQuestionsSearchBarTokenStyleUser,
	kOPFQuestionsSearchBarTokenStyleDefault = kOPFQuestionsSearchBarTokenStyleTag
} OPFQuestionsSearchBarTokenStyle;


extern const CGFloat kOPFTokenTextFontSize;

extern const CGFloat kOPFTokenHeight;
extern const CGFloat kOPFTokenPaddingLeft;
extern const CGFloat kOPFTokenPaddingRight;
extern const CGFloat kOPFTokenPaddingTop;


/**
 Draws a “token” to be used in a search bar (e.g. for tags or users).
 */
@interface OPFQuestionsSearchBarTokenView : UIView

#pragma mark - Initialization and Creation
- (instancetype)initWithStyle:(OPFQuestionsSearchBarTokenStyle)style;


#pragma mark - Style
@property (assign, nonatomic) OPFQuestionsSearchBarTokenStyle style;


#pragma mark - Border
/// The color of the border around the token.
@property (strong, nonatomic) UIColor *borderColor;
/// The width of the border. Defaults to 1.0.
@property (assign, nonatomic) CGFloat borderWidth;


#pragma mark - Background
@property (strong, nonatomic) UIColor *backgroundStartColor;
@property (strong, nonatomic) UIColor *backgroundEndColor;


#pragma mark - Text
/// The text shown.
@property (copy, nonatomic) NSString *text;
/// The text label which will display the string.
///
/// @warning Please use the `text` property to set the token’s label text.
@property (strong, nonatomic, readonly) UILabel *textLabel;

@end
