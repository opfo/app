//
//  NSString+OPFSearchString.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 02-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

// Tag syntax:  [some tag]
extern NSString *const kOPFTokenTagStartCharacter;
extern NSString *const kOPFTokenTagEndCharacter;

// User syntax: @Some cool User@
extern NSString *const kOPFTokenUserStartCharacter;
extern NSString *const kOPFTokenUserEndCharacter;


@interface NSString (OPFSearchString)

- (NSString *)opf_stringAsTagTokenString;
- (NSString *)opf_stringAsUserTokenString;

- (NSArray *)opf_tagsFromSearchString;
- (NSArray *)opf_usersFromSearchString;
- (NSString *)opf_keywordsSearchStringFromSearchString;

@end
