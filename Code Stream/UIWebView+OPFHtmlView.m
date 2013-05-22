//
//  UIWebView+OPFHtmlView.m
//  Code Stream
//
//  Created by Martin Goth on 2013-05-15.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIWebView+OPFHtmlView.h"
#import "NSString+OPFEscapeStrings.h"


#define stringTemplate @"<!-- content -->"
#define widthTemplate @"<!-- width -->"
#define colorTemplate @"<!-- color -->"

@implementation UIWebView (OPFHtmlView)
- (void)opf_loadHTMLString:(NSString *)string {
	
	[self opf_loadHTMLString:string withWidth:@"device-width" andBackgroundColor:@"#fff"];
}

- (void)opf_loadHTMLString:(NSString *)string withWidth:(NSString *)width andBackgroundColor:(NSString	*)color {
	NSMutableString* template = [[NSString alloc] initWithData:opf_template() encoding:NSUTF8StringEncoding].mutableCopy;
	
	id escapedContent = [string OPF_escapeWithScheme:OPFEscapeHtmlPrettify];
	
	[template replaceOccurrencesOfString:stringTemplate withString:escapedContent options:0 range:NSMakeRange(0, [template length])];
	[template replaceOccurrencesOfString:widthTemplate withString:width options:0 range:NSMakeRange(0, [template length])];
	[template replaceOccurrencesOfString:colorTemplate withString:color options:0 range:NSMakeRange(0, [template length])];
	
	[self loadHTMLString:template baseURL:[[NSBundle mainBundle] bundleURL]];
}

NSData* opf_template() {
	return [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bodytemplate" ofType:@"html"]];
}
@end
