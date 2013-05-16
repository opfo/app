//
//  OPFUpdateQuery.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-10.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUpdateQuery.h"
#import "OPFDatabaseAccess.h"
#import <stdlib.h>

@implementation OPFUpdateQuery

+(BOOL) updateWithQuestionTitle: (NSString *) title Body: (NSString *) body Tags: (NSString *) tags ByUser: (NSString *) userName userID: (NSInteger) userID{
    
    // Current date
    NSString *date = [self currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    int id = [self getNextPostId];
    // Query for the SO db
    NSString *query = @"INSERT INTO posts(id, post_type_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, title, tags, answer_count, comment_count, favorite_count) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    NSArray* args = @[@(id), @1, date, @0, @0, body, @(userID), date, title, tags, @0, @0, @0];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray:args auxiliaryUpdate:NO];
    
    // Update the auxiliary db so it become in sync with the SO db
    NSString *auxQuery = @"INSERT INTO posts_index(object_id, main_index_string, tags) values (?,?,?);";
    NSString* index_string = [NSString stringWithFormat:@"%@ %@ %@", [self removeHTMLTags:body], title, userName];
    args = @[@(id), index_string, tags];
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery withArgumentsInArray:args auxiliaryUpdate:YES];
    
    return (succeeded && auxSucceeded);
}

+ (NSInteger) updateWithAnswerText: (NSString *) answerBody ByUser: (NSString *) userName UserID: (NSInteger) userID ParentQuestion: (NSInteger) questionID{
    
    // Current date
    NSString *date = [self currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    // Query to the SO db
    NSString *query = @"INSERT INTO posts(id, post_type_id, parent_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, comment_count) values ((SELECT (MAX(id) + 1) FROM posts), ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    NSArray* args = @[@2, @(questionID), date, @0, @0, answerBody, @(userID), date, @0];
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray: args auxiliaryUpdate:NO];
    
    int id = [self getNextPostId];
    
    // Query to the auxiliary db so it will be in sync with the SO db
    NSString *auxQuery = @"INSERT INTO posts_index(object_id, aux_index_string) values (?,?);";
    
    args = @[@(questionID), [self removeHTMLTags:answerBody]];
    
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery withArgumentsInArray: args auxiliaryUpdate:YES];
    
    return succeeded && auxSucceeded ? id : 0;
}

+(NSInteger) updateWithCommentText: (NSString *) commentText PostID: (NSInteger) postID ByUser: (NSInteger) userID{
    
    // Current date
    NSString *date = [self currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    int id = [self getNextPostId];
    
    // Query to the SO db
    NSString *query = [NSString stringWithFormat:@"INSERT INTO comments(id, post_id, score, text, creation_date, user_id) values (?,?,?,?,?,?);"];
    
    NSArray* args = @[@(id), @(postID), @0, commentText, date, @(userID)];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray: args auxiliaryUpdate:NO];
    
    return succeeded ? id:0;

}

+(BOOL) updateWithUserName: (NSString *) name EmailHash: (NSString *) email Website: (NSString *) website Location: (NSString *) location Age: (NSInteger) age Bio: (NSString *) bio{
    
    // Current date
    NSString *date = [self currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    int id = [self getNextPostId];
    
    // Query to the SO db
    NSString *query = @"INSERT INTO users(id, reputation, creation_date, display_name, email_hash, last_access_date, website_url, location, age, about_me, views, up_votes, down_votes) values (?,?,?,?,?,?, ?, ?, ?, ?, ?, ?, ?);";
    
    NSArray* args = @[@(id), @0, date, name, email, date, website, location, @(age), bio, @0, @0, @0];
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray: args auxiliaryUpdate:NO];
    

    // Query to the auxiliary db to keep it in sync with the SO db
    NSString *auxQuery = @"INSERT INTO users_index(object_id, index_string) values (?, ?);";
    args = @[@(id), name];
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery withArgumentsInArray:args auxiliaryUpdate:YES];

    return succeeded && auxSucceeded;
}

// Return current date
+(NSString *) currentDateAsStringWithDateFormat: (NSString *) format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString *) removeHTMLTags:(NSString *)input
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<([^<>]+)>" options:0 error:&error];
    NSString* output = [regex stringByReplacingMatchesInString:input options:0 range:NSMakeRange(0, [input length]) withTemplate:@""];
    return output;
}

+(int) getNextPostId
{
    __block NSNumber* id;
    [[[OPFDatabaseAccess getDBAccess] combinedQueue] inDatabase:^(FMDatabase* db){
        FMResultSet* result = [db executeQuery:@"SELECT MAX(id) FROM posts"];
        if([result next]) {
            id = @([result intForColumnIndex:0]);
        }
    }];
    return [id integerValue] + 1;
}

@end


// Temporary code to test if update was as intended
/*NSString *sql = [NSString stringWithFormat:@"SELECT * FROM posts WHERE title='%@'",title];
 
 FMResultSet *results =  [[OPFDatabaseAccess getDBAccess] executeSQL:sql];
 
 while([results next]) {
 NSString *title = [results stringForColumn:@"title"];
 NSInteger postID  = [results intForColumn:@"id"];
 NSInteger post_type_id  = [results intForColumn:@"post_type_id"];
 NSLog(@"Post ID: %d \nPosttype: %d \ntitle: %@", postID, post_type_id, title);
 }*/
