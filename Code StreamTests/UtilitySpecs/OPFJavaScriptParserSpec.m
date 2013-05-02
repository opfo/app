//
//  OPFJavaScriptParserSpec.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-29.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFPostBodyTableViewCell.h"
#import "NSString+OPFEscapeStrings.h"

SpecBegin(JavaScriptParser)

describe(@"escaping HTML for Java Script", ^{
	
	NSString* (^convert)(NSString*) = ^(NSString* string) {return [string OPF_escapeWithScheme:OPFEscapePrettify];};
	
	it(@"translates HTML Tags without modification", ^{
		expect(convert(@"<html>test</html>")).
		to.equal(@"<html>test</html>");
	});
	
	
	it(@"escapes line breaks", ^{
		expect(convert(@"l1\nl2")).
		to.equal(@"l1\\nl2");
	});
	
	it(@"escapes HTML attributes", ^{
		expect(convert(@"<a href=\"\"http://www.nservicebus.com/Gateway.aspx\"\" rel=\"\"nofollow\"\">")).
		to.equal(@"<a href=\\\"http://www.nservicebus.com/Gateway.aspx\\\" rel=\\\"nofollow\\\">");
	});
});

SpecEnd
