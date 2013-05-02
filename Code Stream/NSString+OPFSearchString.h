//
//  NSString+OPFSearchString.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 02-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OPFSearchString)

- (NSArray *)opf_tagsFromSearchString;
- (NSArray *)opf_usersFromSearchString;
- (NSString *)opf_keywordsSearchStringFromSearchString;

@end
