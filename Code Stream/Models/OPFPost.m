//
//  OPFPost.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPost.h"
#import "OPFAnswer.h"
#import "OPFQuestion.h"

@implementation OPFPost

+ (NSString *) modelTableName
{
    return @"posts";
}

- (NSArray * ) comments {
    return NULL;
}

//  Takes a dictionary and returns a populated model class
+ (instancetype) parseDictionary: (NSDictionary*) attributes {
    NSError* error;
    Class klass;
    if ([[attributes valueForKey:@"post_type_id"] integerValue] == KOPF_POST_TYPE_ANSWER) {
        klass = [OPFAnswer class];
    } else {
        klass = [OPFQuestion class];
    }
    return [MTLJSONAdapter modelOfClass: klass fromJSONDictionary:attributes error: &error];
}

//
// Translates incoming dictionary keys into the names of the target properties
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"creationDate": @"creation_date",
             @"postType": @"post_type_id",
             @"score": @"score",
             @"viewCount": @"view_count",
             @"title": @"title",
             @"body": @"body",
             @"ownerId": @"owner_user_id",
             @"lastEditorId": @"last_editor_user_id",
             @"lastEditorDisplayName": @"last_editor_display_name",
             @"lastEditDate": @"last_edit_date",
             @"lastActivityDate": @"last_activity_date",
             @"communityOwnedDate": @"community_owned_date",
             @"commentCount": @"comment_count",
             @"favoriteCount": @"favorite_count"
   };
}

+ (NSValueTransformer*) lastEditDateJSONTransformer
{
    return [self standardDateTransformer];
}

+ (NSValueTransformer*) lastActivityDateJSONTransformer
{
    return [self standardDateTransformer];
}

+ (NSValueTransformer*) communityOwnedDateJSONTransformer
{
    return [self standardDateTransformer];
}

@end
