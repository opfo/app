//
//  OPFQuestionsSearchBar.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsSearchBar.h"
#import "OPFQuestionsSearchBarTokenView.h"


@interface OPFQuestionsSearchBarToken ()
@property (strong) OPFQuestionsSearchBarTokenView *view;
@end

@implementation OPFQuestionsSearchBarToken
+ (instancetype)tokenWithRange:(NSRange)range type:(OPFQuestionsSearchBarTokenType)type text:(NSString *)text
{
	return [[self alloc] initWithRange:range type:type text:text];
}

- (instancetype)initWithRange:(NSRange)range type:(OPFQuestionsSearchBarTokenType)type text:(NSString *)text
{
	self = [super init];
	if (self) {
		_text = text.copy;
		_range = range;
		_type = type;
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p range = %@; type = %d; text = %@>", self.class, self, NSStringFromRange(self.range), self.type, self.text];
}

@end


@implementation OPFQuestionsSearchBar

- (void)sharedQuestionsSearchBarInit
{
	for (UIView *subview in self.subviews) {
		if ([subview isKindOfClass:UITextField.class]) {
			_textField = (UITextField *)subview;
			break;
		}
	}
	
	_tokens = NSArray.new;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) [self sharedQuestionsSearchBarInit];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) [self sharedQuestionsSearchBarInit];
	return self;
}

- (void)setTokens:(NSArray *)tokens
{
	if (_tokens != tokens) {
		for (OPFQuestionsSearchBarToken *token in _tokens) {
			[token.view removeFromSuperview];
		}
		
		_tokens = tokens.copy;
		
		for (OPFQuestionsSearchBarToken *token in _tokens) {
			OPFQuestionsSearchBarTokenStyle style = (token.type == kOPFQuestionsSearchBarTokenUser ? kOPFQuestionsSearchBarTokenStyleUser : kOPFQuestionsSearchBarTokenStyleTag);
			token.view = [[OPFQuestionsSearchBarTokenView alloc] initWithStyle:style];
			token.view.text = token.text;
			[self addSubview:token.view];
		}
		
		[self setNeedsLayout];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	for (OPFQuestionsSearchBarToken *token in _tokens) {
		OPFQuestionsSearchBarTokenView *tokenView = token.view;
		
	}
}

/*
 Le idea #1
 
 1. Take in search text (in some way, either programatically by setting
	`self.text` or by the user entering stuff via the UI).
 2. Parse search text for tags
 3. Add each tag to a buffer to be rendered.
 4. 
 
 
 Le idea #2
 
 */


@end
