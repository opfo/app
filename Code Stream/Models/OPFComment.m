//
//  OPFComment.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFComment.h"

@implementation OPFComment

+ (NSString *) modelTableName
{
    return @"comments";
}

+ (NSArray *) where:(NSDictionary *)attributes
{
    return nil;
}

//
// Translates incoming dictionary keys into the names of the target properties
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"post_id": @"post_id",
             @"score": @"score",
             @"text": @"text",
             @"creationDate": @"creation_date",
             @"author_id": @"user_id"
    };
}

+ (instancetype) parseDictionary: (NSDictionary*) attributes {
    NSError* error;
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:attributes error: &error];
}

@end
