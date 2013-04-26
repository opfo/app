//
//  OPFTag.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-24.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFModel.h"

@interface OPFTag : OPFModel

@property (strong) NSNumber* identifier;
@property (copy) NSString* name;
@property (strong, readonly)NSArray* questions;

// Transforms an array of strings into a string of tags
//      Example:    [OPFTag arrayToRawTags: @[@"apa", @"bepa"]];
//                  => "<apa><bepa>"
+ (NSString*) arrayToRawTags: (NSArray*) array;
+ (NSArray*) rawTagsToArray: (NSString*) rawTags;

// Get a tag by name
+ (instancetype) byName: (NSString*) name;

@end
