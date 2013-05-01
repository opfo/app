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
#import "OPFComment.h"

@interface OPFPost(/*Private*/)

+(NSString*) matchClauseFromSearchString: (NSString*) searchString;

@end

@implementation OPFPost

+ (NSString *) modelTableName
{
    return @"posts";
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
             @"favoriteCount": @"favorite_count",
             @"closedDate": @"closed_date",
             @"acceptedAnswerId": @"accepted_answer_id",
             @"rawTags": @"tags",
             @"tags" :@"tags",
             @"answerCount": @"answer_count",
             @"parentId" : @"parent_id"
             
             
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

@synthesize comments = _comments;

- (NSArray * ) comments {
    if(_comments == nil) {
        OPFQuery* query = [[OPFComment query] whereColumn:@"post_id" is: self.identifier];
        _comments = [query getMany];
    }
    return _comments;
}

@synthesize owner = _owner;

- (OPFUser*) owner
{
    if (_owner == nil) {
        OPFQuery* query = [[OPFUser query] whereColumn:@"id" is: self.ownerId];
        _owner = [query getOne];
    }
    return _owner;
}

- (void) setOwner:(OPFUser *)owner
{
    _owner = owner;
    [self setOwnerId: owner.identifier];
}

@synthesize lastEditor = _lastEditor;

- (OPFUser*) lastEditor
{
    if (_lastEditor == nil) {
        OPFQuery* query = [[OPFUser query] whereColumn:@"id" is: self.lastEditorId];
        _lastEditor = [query getOne];
    }
    return _lastEditor;
}

- (void) setLastEditor:(OPFUser *)lastEditor
{
    if (_lastEditor != lastEditor) {
        _lastEditor = lastEditor;
        [self setLastEditorId: lastEditor.identifier];
    }
}

# pragma mark - Full text search methods

+ (OPFQuery*) searchFor:(NSString *)searchTerms
{
    NSString* queryFormat = @"SELECT post_id FROM posts_index WHERE index_string MATCH %@";
    NSString* output = [NSString stringWithFormat:queryFormat, [self matchClauseFromSearchString:searchTerms]];
    FMResultSet* result = [[OPFDatabaseAccess getDBAccess] executeSQL:output withDatabase:@"auxDB"];
    NSMutableArray* postIds = [[NSMutableArray alloc] init];
    while ([result next]) {
        [postIds addObject: @([result intForColumn:@"post_id"])];
    }
    return [[self query] whereColumn:@"id" in:postIds];
}

+ (NSString*) matchClauseFromSearchString: (NSString*) searchString
{
    /**
     This method could later be used to tweak the query string.
     For now we will return the input.
     For example usage see below:
     
    NSArray* tokens = [searchString componentsSeparatedByString:@" "];
    NSMutableArray* wildCardTokens = [[NSMutableArray alloc] initWithCapacity: [tokens count]];
    for(id token in tokens) {
        [wildCardTokens addObject:[NSString stringWithFormat:@"%@*", token]];
    }
    NSString* output = [wildCardTokens componentsJoinedByString:@" AND "];
    return output;
     */
    return [NSString stringWithFormat:@"'%@'", searchString];
}

@end
