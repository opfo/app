//
//  UIWebView+OPFHtmlView.m
//  Code Stream
//
//  Created by Martin Goth on 2013-05-15.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIWebView+OPFHtmlView.h"
#import "NSString+OPFEscapeStrings.h"



@implementation UIWebView (OPFHtmlView)
- (void)opf_loadHTMLString:(NSString *)string {
	
	NSString *template = [[NSString alloc] initWithData:opf_template() encoding:NSUTF8StringEncoding];
	NSString *command = [template stringByReplacingOccurrencesOfString:@"<!-- content -->" withString:[string OPF_escapeWithScheme:OPFEscapeHtmlPrettify]];
	
	
	[self loadHTMLString:command baseURL:[[NSBundle mainBundle] bundleURL]];
}

NSData* opf_template() {
	return [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bodytemplate" ofType:@"html"]];
}
@end
