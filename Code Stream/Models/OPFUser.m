//
//  User.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUser.h"
#import "OPFDatabaseAccess.h"
#import "OPFQuestion.h"
#import "OPFComment.h"
#import "OPFAnswer.h"

@interface OPFUser (/*private */)
@property(strong, readwrite) NSNumber* identifier;
@property(strong, readwrite) NSDate* creationDate;
@end

@implementation OPFUser

+ (NSString*) modelTableName {
    return @"users";
}

-(OPFQuery*) answers
{
    return [[OPFAnswer query] whereColumn:@"owner_user_id" is:self.identifier];
}

-(OPFQuery*) questions
{
    return [[OPFQuestion query] whereColumn:@"owner_user_id" is: self.identifier];
}

-(OPFQuery*) comments
{
    return [[OPFComment query] whereColumn:@"user_id" is:self.identifier];
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
+ (NSValueTransformer *)lastAccessDateJSONTransformer {
    return [self standardDateTransformer];
}

// Used to build full text queries
+(NSString*) indexTableName
{
    return @"users_index";
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p id = %@; display name = %@>", self.class, self, self.identifier, self.displayName];
}


@end
