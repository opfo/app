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

+ (NSArray *) all
{
    return nil;
}

+ (NSArray *) where:(NSDictionary *)attributes
{
    return nil;
}

+ (instancetype) find:(NSInteger)identifier
{
    FMResultSet* result = [self findModel: [self modelTableName] withIdentifier: identifier];
    NSError* error;
    if([result next]) {
        NSLog(@"Found a result at least");
        NSDictionary* attributes = [result resultDictionary];
        [[result resultDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* STOP){
            NSLog([NSString stringWithFormat:@"Key: %@, Obj: %@", key, obj]);
        }];
        OPFComment* comment =[MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:attributes error: &error];
        [result close];
        return comment;
    } else {
        NSLog(@"Apparently we found nothing");
        [result close];
        return nil;
    }
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

@end
