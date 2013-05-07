//
//  OPFSearchBarHeader.m
//  Code Stream
//
//  Created by Martin Goth on 2013-05-07.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSearchBarHeader.h"
#import <BlocksKit.h>

@implementation OPFSearchBarHeader
@synthesize headerDisplayed = _headerDisplayed;

- (void)setHeaderDisplayed:(DisplayHeader)headerDisplayed {
	CGRect target = CGRectNull;
	switch (headerDisplayed) {
		case SearchBar:
			target = self.searchBar.frame;
			break;
		case SortControl:
			target = CGRectMake(320, 0, 320, 44);
			break;
		default:
			@throw @"Display Header not found. Define enum in OPFQuestionSearchBar.h";
			break;
	}
	[self scrollRectToVisible:target animated:YES];
	_headerDisplayed = headerDisplayed;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self sharedInit];
	}
	return self;
}

- (void)sharedInit {
	self.headerDisplayed = SearchBar;
}

- (IBAction)handleSwitchEvent:(UIButton *)sender {
	self.headerDisplayed = (DisplayHeader)sender.tag;
}


@end
