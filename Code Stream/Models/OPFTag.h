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
@property (readonly)NSArray* questions;

+ (NSString*) arrayToRawTags: (NSArray*) array;
+ (NSArray*) rawTagsToArray: (NSString*) rawTags;

@end
