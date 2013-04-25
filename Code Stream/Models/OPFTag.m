//
//  OPFTag.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-24.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTag.h"
#import "OPFQuestion.h"

@implementation OPFTag

+ (NSString*) dbName
{
    return @"auxDB";
}

//
// Translates incoming dictionary keys into the names of the target properties
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"name": @"name"
             };
}

@synthesize questions = _questions;

- (NSArray*) questions
{
    if (_questions == nil) {
        OPFQuery* query = [[OPFQuestion query] whereColumn:@"tags" like: [NSString stringWithFormat:@"%%%@%%", self.name]];
        _questions = [query getMany];
    }
    return _questions;
}

+ (NSString*) modelTableName
{
    return @"tags";
}

+ (NSString*) arrayToRawTags:(NSArray *)array
{
    return nil;
}

+ (NSArray*) rawTagsToArray:(NSString *)rawTags
{
    return nil;
}

@end
