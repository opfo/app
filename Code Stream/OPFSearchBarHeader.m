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

-(void)setDisplayedHeader:(DisplayHeader)page WithAnimation:(BOOL) animated {
	CGRect target = self.frame;
	target.origin.x = self.frame.size.width * (int)page;
	[self scrollRectToVisible:target animated:animated];
}

- (void)setDisplayedHeader:(DisplayHeader)displayedHeader {
	[self setDisplayedHeader:displayedHeader WithAnimation:YES];
}

- (DisplayHeader)displayedHeader {
	return (DisplayHeader)self.contentOffset.x / self.frame.size.width;
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
	self.displayedHeader = SearchBar;
}

- (void)handleSwitchEvent:(UIButton *)sender {
	self.displayedHeader = (DisplayHeader)sender.tag;
}





@end
