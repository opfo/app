//
//  NSRegularExpression+OPFSearchString.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 02-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "NSRegularExpression+OPFSearchString.h"

@implementation NSRegularExpression (OPFSearchString)

+ (NSRegularExpression *)opf_tagsFromSearchStringRegularExpression
{
	static NSRegularExpression *_tagsRegularExpression = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError *error = NULL;
		_tagsRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\[([^\\[]+)\\]" options:0 error:&error];
		ZAssert(_tagsRegularExpression != nil, @"Could not create regular expression, got the error: %@", error);
	});
	return _tagsRegularExpression;
}

+ (NSRegularExpression *)opf_usersFromSearchStringRegularExpression
{
	static NSRegularExpression *_usersRegularExpression = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError *error = NULL;
		_usersRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"@([^@]+)@" options:0 error:&error];
		ZAssert(_usersRegularExpression != nil, @"Could not create regular expression, got the error: %@", error);
	});
	return _usersRegularExpression;
}

+ (NSRegularExpression *)opf_nonKeywordsFromSearchStringRegularExpression
{
	static NSRegularExpression *_nonKeywordsRegularExpression = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError *error = NULL;
		_nonKeywordsRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"@([^@]+)@|\\[([^\\[]+)\\]" options:0 error:&error];
		ZAssert(_nonKeywordsRegularExpression != nil, @"Could not create regular expression, got the error: %@", error);
	});
	return _nonKeywordsRegularExpression;
}

@end
