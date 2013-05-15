//
//  OPFQuestionsSearchBarAccessoryButtonsView.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 30-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsSearchBarInputButtonsView.h"
#import "UIFont+OPFAppFonts.h"

@implementation OPFQuestionsSearchBarInputButtonsView

- (void)awakeFromNib
{
	UIFont *font = [UIFont opf_boldAppFontOfSize:15.f];
	self.insertNewTagButton.titleLabel.font = font;
	self.insertNewUserButton.titleLabel.font = font;
}

@end
