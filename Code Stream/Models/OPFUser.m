//
//  User.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUser.h"
#import "OPFDatabaseAccess.h"

@interface OPFUser (/*private */)
@property(assign, readwrite) NSInteger identifier;
@property(strong, readwrite) NSDate* creationDate;
@end

@implementation OPFUser

+ (NSString*) modelTableName {
    return @"users";
}

- (NSArray*) questionsPage:(NSInteger)page
{
    return nil;
}

- (NSArray*) answersPage:(NSInteger)page
{
    return nil;
}

- (NSArray*) commentsPage:(NSInteger)page
{
    return nil;
}

//
// Translates incoming dictionary keys into the names of the target properties
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"reputation": @"reputation",
             @"displayName": @"display_name",
             @"emailHash": @"email_hash",
             @"creationDate": @"creation_date",
             @"lastAccessDate": @"last_access_date",
             @"websiteUrl": @"website_url",
             @"location": @"location",
             @"age": @"age",
             @"aboutMe": @"about_me",
             @"views": @"views",
             @"upVotes": @"up_votes",
             @"downVotes": @"down_votes"
             };
}

// Automagically transform website_url into a NSUrl
+ (NSValueTransformer *)websiteUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
