//
//  OPFPostBodyTableViewCell.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostBodyTableViewCell.h"

@implementation OPFPostBodyTableViewCell
@synthesize htmlString = _htmlString;

- (void)setHtmlString:(NSString *)htmlString {
	_htmlString = htmlString;
	[self.bodyTextView loadHTMLString:htmlString baseURL:0];
}

- (void)awakeFromNib {
	self.bodyTextView.keyboardDisplayRequiresUserAction = NO;
	self.bodyTextView.mediaPlaybackAllowsAirPlay = NO;
	self.bodyTextView.mediaPlaybackRequiresUserAction = NO;
}

@end
