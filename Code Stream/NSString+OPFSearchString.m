//
//  NSString+OPFSearchString.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 02-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "NSString+OPFSearchString.h"
#import "NSString+OPFStripCharacters.h"
#import "NSRegularExpression+OPFSearchString.h"
#import "OPFTag.h"

// Tag syntax:  [some tag]
NSString *const kOPFTokenTagStartCharacter = @"[";
NSString *const kOPFTokenTagEndCharacter = @"]";

// User syntax: @Some cool User@
NSString *const kOPFTokenUserStartCharacter = @"@";
NSString *const kOPFTokenUserEndCharacter = @"@";


@implementation NSString (OPFSearchString)

#pragma mark - Getting Tags, Users and Keywords From Search Input
- (NSArray *)opf_tagsFromSearchString
{
	NSRegularExpression *regularExpression = NSRegularExpression.opf_tagsFromSearchStringRegularExpression;
	NSArray *tags = [self opf_tokensFromSearchStringUsingRegularExpression:regularExpression creation:^id(NSString *token) {
		return [OPFTag byName:token];
	}];
	return tags;
}

- (NSArray *)opf_usersFromSearchString
{
	NSRegularExpression *regularExpression = NSRegularExpression.opf_usersFromSearchStringRegularExpression;
	NSArray *users = [self opf_tokensFromSearchStringUsingRegularExpression:regularExpression creation:nil];
	return users;
}

- (NSString *)opf_keywordsSearchStringFromSearchString
{
	NSString *keywordSearchString = @"";
	if (self.length > 0) {
		NSRegularExpression *replacementRgularExpression = NSRegularExpression.opf_nonKeywordsFromSearchStringRegularExpression;
		keywordSearchString = [replacementRgularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@" "];
		
		keywordSearchString = keywordSearchString.opf_stringByTrimmingWhitespace;
	}
	
	return keywordSearchString;
}


#pragma mark - Private Token Parser
- (NSArray *)opf_tokensFromSearchStringUsingRegularExpression:(NSRegularExpression *)regularExpression creation:(id (^)(NSString *token))creationBlock
{
	NSParameterAssert(regularExpression != nil);
	
	NSMutableSet *tokens = NSMutableSet.new;
	// The shortest possible tag is `[a]`, i.e. three (3) chars.
	if (self.length >= 3) {
		if (creationBlock == nil) {
			creationBlock = ^(NSString *token) { return token; };
		}
		
		[regularExpression enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			if ([result numberOfRanges] >= 2) {
				NSRange caputerRange = [result rangeAtIndex:1];
				NSString *capture = [self substringWithRange:caputerRange];
				
				id token = creationBlock(capture.opf_stringByTrimmingWhitespace);
				if (token != nil) {
					[tokens addObject:token];
				}
			}
		}];
	}
	return tokens.allObjects;
}


#pragma mark -
- (NSString *)opf_stringAsTagTokenString
{
	return [NSString stringWithFormat:@"%@%@%@", kOPFTokenTagStartCharacter, self, kOPFTokenTagEndCharacter];
}

- (NSString *)opf_stringAsUserTokenString
{
	return [NSString stringWithFormat:@"%@%@%@", kOPFTokenUserStartCharacter, self, kOPFTokenUserEndCharacter];
}


@end
