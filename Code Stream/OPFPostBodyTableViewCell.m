//
//  OPFPostBodyTableViewCell.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostBodyTableViewCell.h"
#import "NSString+OPFEscapeStrings.h"
#import "OPFQuestion.h"
#import "OPFQuestionViewController.h"
#import "OPFWebViewController.h"

@implementation OPFPostBodyTableViewCell


- (void)awakeFromNib {
	self.bodyTextView.keyboardDisplayRequiresUserAction = NO;
	self.bodyTextView.mediaPlaybackAllowsAirPlay = NO;
	self.bodyTextView.mediaPlaybackRequiresUserAction = NO;
	self.bodyTextView.dataDetectorTypes = UIDataDetectorTypeNone;
	self.bodyTextView.scrollView.scrollEnabled = NO;
	self.bodyTextView.scrollView.bounces = NO;
	self.bodyTextView.suppressesIncrementalRendering = YES;
	
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"bodytemplate" ofType:@"html"];
	NSURL *bundle = [[NSBundle mainBundle] bundleURL];

	if (htmlPath && bundle) {
        NSData *htmlData = [NSData dataWithContentsOfFile:htmlPath];
        [self.bodyTextView loadData:htmlData MIMEType:@"text/html"
						textEncodingName:@"utf-8" baseURL:bundle];
    }
	
}

-(void)dealloc {
	self.bodyTextView.delegate = nil;
}

@end
