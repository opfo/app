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
	
	if (!self.bodyTextView.loading)
		[self reloadHTMLWithString:htmlString];
}

+ (NSString*)escapeJavaScriptWithString:(NSString*)unescaped {
	NSLog(@"From: %@\n\n",unescaped);
	NSMutableString *myRepr = [[NSMutableString alloc] initWithString:unescaped];
	NSRange myRange = NSMakeRange(0, [unescaped length]);
	NSArray *toReplace = [NSArray arrayWithObjects:@"\0", @"\a", @"\b", @"\t", @"\n", @"\f", @"\r", @"\e", @"\"", nil];
	NSArray *replaceWith = [NSArray arrayWithObjects:@"\\0", @"\\a", @"\\b", @"\\t", @"\\n", @"\\f", @"\\r", @"\\e", @"\\\"", nil];
	for (int i = 0, count = [toReplace count]; i < count; ++i) {
		[myRepr replaceOccurrencesOfString:[toReplace objectAtIndex:i] withString:[replaceWith objectAtIndex:i] options:0 range:myRange];
	}
	NSString *retStr = [NSString stringWithFormat:@"%@", myRepr];
	NSLog(@"To: %@\n\n",retStr);
	return retStr;
}

- (void)reloadHTMLWithString:(NSString *)content {
	NSString *command = [NSString stringWithFormat:@"loadBody(\"%@\")", [OPFPostBodyTableViewCell escapeJavaScriptWithString:content]];
	[self.bodyTextView stringByEvaluatingJavaScriptFromString:command];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self reloadHTMLWithString:_htmlString];
}

- (void)awakeFromNib {
	self.bodyTextView.keyboardDisplayRequiresUserAction = NO;
	self.bodyTextView.mediaPlaybackAllowsAirPlay = NO;
	self.bodyTextView.mediaPlaybackRequiresUserAction = NO;
	self.bodyTextView.delegate = self;
	
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"bodytemplate" ofType:@"html"];
	NSURL *bundle = [[NSBundle mainBundle] bundleURL];

	if (htmlPath && bundle) {
        NSData *htmlData = [NSData dataWithContentsOfFile:htmlPath];
        [self.bodyTextView loadData:htmlData MIMEType:@"text/html"
						textEncodingName:@"utf-8" baseURL:bundle];
    }
}

@end
