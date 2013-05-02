//
//  NSString+OPFSearchString.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 02-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "NSString+OPFSearchString.h"
#import "NSString+OPFStripCharacters.h"

@implementation NSString (OPFSearchString)

#pragma mark - Getting Tags, Users and Keywords From Search Input
- (NSArray *)opf_tagsFromSearchString
{
	NSRegularExpression *regularExpression = self.class.opf_tagsFromSearchStringRegularExpression;
	NSArray *tags = [self opf_tokensFromSearchStringUsingRegularExpression:regularExpression];
	return tags;
}

- (NSArray *)opf_usersFromSearchString
{
	NSRegularExpression *regularExpression = self.class.opf_usersFromSearchStringRegularExpression;
	NSArray *users = [self opf_tokensFromSearchStringUsingRegularExpression:regularExpression];
	return users;
}

- (NSString *)opf_keywordsSearchStringFromSearchString
{
	NSString *keywordSearchString = @"";
	if (self.length > 0) {
		NSRegularExpression *replacementRgularExpression = self.class.opf_nonKeywordsFromSearchStringRegularExpression;
		keywordSearchString = [replacementRgularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@" "];
		
		keywordSearchString = keywordSearchString.opf_stringByTrimmingWhitespace;
	}
	
	return keywordSearchString;
}


#pragma mark - Private Token Parser
- (NSArray *)opf_tokensFromSearchStringUsingRegularExpression:(NSRegularExpression *)regularExpression
{
	NSParameterAssert(regularExpression != nil);
	
	NSMutableSet *tokens = NSMutableSet.new;
	// The shortest possible tag is `[a]`, i.e. three (3) chars.
	if (self.length >= 3) {
		[regularExpression enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			if ([result numberOfRanges] >= 2) {
				NSRange caputerRange = [result rangeAtIndex:1];
				NSString *capture = [self substringWithRange:caputerRange];
				[tokens addObject:capture.opf_stringByTrimmingWhitespace];
			}
		}];
	}
	return tokens.allObjects;
}


#pragma mark - Regular Expressions
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
