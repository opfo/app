//
//  OPFQuestionsSearchBar.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsSearchBar.h"
#import "OPFQuestionsSearchBarTokenView.h"
#import "UIColor+OPFHEX.h"
#import "SSLineView.h"

#import <objc/runtime.h>

#define sortButtonSize 24
#define padding 5

@interface OPFQuestionsSearchBarToken ()
@property (strong) UIView *view;
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
	// Add sort Button
	self.sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.sortButton.frame = CGRectMake(
									   CGRectGetWidth(self.bounds)-sortButtonSize-5,
									   10,
									   sortButtonSize, sortButtonSize);
	self.sortButton.titleLabel.text = @"Sort";
	
	[self addSubview:self.sortButton];
	
	// Add sort order selector
	self.sortOrder = [[UISegmentedControl alloc] initWithItems:@[@"Score",@"Activity",@"Created"]];
	self.sortOrder.selectedSegmentIndex = 0;
					  
	self.sortOrder.frame = CGRectMake(padding,
																		 padding,
																		 CGRectGetWidth(self.bounds) - 2*padding,
																		 CGRectGetHeight(self.bounds) - 2*padding);
	[self addSubview:self.sortOrder];

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
		
//		for (OPFQuestionsSearchBarToken *token in _tokens) {
//			OPFQuestionsSearchBarTokenStyle style = (token.type == kOPFQuestionsSearchBarTokenUser ? kOPFQuestionsSearchBarTokenStyleUser : kOPFQuestionsSearchBarTokenStyleTag);
//			OPFQuestionsSearchBarTokenView *tokenView = [[OPFQuestionsSearchBarTokenView alloc] initWithStyle:style];
//			tokenView.text = token.text;
//			UIView *tokenWrapperView = UIView.new;
//			[tokenWrapperView addSubview:tokenView];
//			token.view = tokenWrapperView;
//			[self.textField addSubview:token.view];
//		}
//		
//		[self setNeedsLayout];
	}
}

- (BOOL)becomeFirstResponder
{
	[self setNeedsLayout];
	return [super becomeFirstResponder];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGFloat insetTop = 4.f;
	CGFloat baseInsetLeft = 30.f;
	
	CGRect searchBarFrame = self.textField.frame;
	searchBarFrame.size.width = CGRectGetWidth(self.bounds) - sortButtonSize - 15; // Insert width of button
	self.textField.frame = searchBarFrame;
	
	for (OPFQuestionsSearchBarToken *token in _tokens) {
		CGRect tokenFrame = token.view.frame;
		tokenFrame.origin.y = tokenFrame.origin.y + insetTop;
		tokenFrame.origin.x = tokenFrame.origin.x + baseInsetLeft + token.range.location * 8;
		tokenFrame.size.height = 22.f;
		token.view.frame = tokenFrame;
	}
}


@end
