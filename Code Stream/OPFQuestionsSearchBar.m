//
//  OPFQuestionsSearchBar.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsSearchBar.h"

NSString *const kOPFQuestionsSearchBarTypeName = @"OPFQuestionsSearchBarTypeName";
NSString *const kOPFQuestionsSearchBarTypeTagAttribute = @"OPFQuestionsSearchBarTypeTagAttribute";
NSString *const kOPFQuestionsSearchBarTypeUserAttribute = @"OPFQuestionsSearchBarTypeUserAttribute";


@implementation OPFQuestionsSearchBar

- (void)sharedQuestionsSearchBarInit
{
	for (UIView *subview in self.subviews) {
		if ([subview isKindOfClass:UITextField.class]) {
			_textField = (UITextField *)subview;
			break;
		}
	}
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
