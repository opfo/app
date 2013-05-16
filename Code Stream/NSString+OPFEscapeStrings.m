//
//  NSString+OPFEscapeStrings.m
//  Code Stream
//
//  Created by Martin Goth on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "NSString+OPFEscapeStrings.h"

@implementation NSString (OPFEscapeStrings)

- (NSString *)OPF_escapeWithScheme:(OPFEscapeScheme)scheme {
	NSMutableString *myRepr = self.mutableCopy;
	NSRange myRange = NSMakeRange(0, [self length]);
	
	NSArray *toReplace = nil;
	NSArray *replaceWith = nil;
	
	switch (scheme) {
		case OPFEscapePrettify:
			toReplace = @[@"\0", @"\a", @"\b", @"\t", @"\n", @"\f", @"\r", @"\e", @"\"\"", @"<pre>"];
			replaceWith = @[@"\\0", @"\\a", @"\\b", @"\\t", @"\\n", @"\\f", @"\\r", @"\\e", @"\\\"", @"<pre class=\\\"prettyprint\\\">"];
			break;
		case OPFEscapeHtml:
			toReplace = @[@"\\n", @"\"\""];
			replaceWith = @[@"\n ", @"\" "];
			break;
        case OPFStripAscii:
			toReplace = @[@"\\n", @"\"\""];
			replaceWith = @[@"\" ", @"\" "];
			break;
		case OPFEscapeHtmlPrettify:
			toReplace = @[@"\\n", @"\"\"", @"<pre>"];
			replaceWith = @[@"\n ", @"\" ", @"<pre class=\"prettyprint\">"];
			break;
		default:
			@throw @"Unknown escape scheme. Have you defined in the OPFEscapeStrings method?";
			break;
	}
	
	for (int i = 0, count = [toReplace count]; i < count; ++i) {
		[myRepr replaceOccurrencesOfString:[toReplace objectAtIndex:i] withString:[replaceWith objectAtIndex:i] options:0 range:myRange];
	}
	
	NSString *retStr = [NSString stringWithFormat:@"%@", myRepr];
	return retStr;
}

@end
