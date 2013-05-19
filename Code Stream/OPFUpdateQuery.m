//
//  OPFUpdateQuery.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-10.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUpdateQuery.h"
#import "OPFDatabaseAccess.h"
#import "OPFQuestion.h"
#import <stdlib.h>
#import "OPFDateFormatter.h"
#import "OPFDBInsertionIdentifier.h"

@implementation OPFUpdateQuery


+(BOOL) insertInto: (NSString *) tableName forColumns: (NSArray *) attributes values:(NSArray *) values auxiliaryDB: (BOOL) auxDB{
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@(",tableName];
    
    for(NSUInteger i=0;i<[attributes count];i++){
        if(i!=[attributes count]-1)
            query = [query stringByAppendingFormat:@"%@,", [attributes objectAtIndex:i]];
        else
           query = [query stringByAppendingFormat:@"%@", [attributes objectAtIndex:i]];
    }
    query = [query stringByAppendingString:@") VALUES("];
    for(NSUInteger i=0;i<[attributes count];i++){
        if(i!=[attributes count]-1)
            query = [query stringByAppendingString:@"?,"];
        else
            query = [query stringByAppendingString:@"?);"];
    }
    NSLog(@"%@",query);
    
    BOOL succeeded = auxDB ? [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray:values auxiliaryUpdate:YES] :
    [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray:values auxiliaryUpdate:auxDB];
    
    NSLog(@"Insert succeeded: %i \nAuxDB? %i",succeeded,auxDB);
    
    return succeeded;
}

+ (BOOL) updateWithAnswerText: (NSString *) answerBody ByUser: (NSString *) userName UserID: (NSInteger) userID ParentQuestion: (NSInteger) questionID{
    
    // Current date
    NSString *date = [OPFDateFormatter currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    int id = [OPFDBInsertionIdentifier getNextPostId];
    
    // Query to the SO db
    NSArray* args = @[@(id),@2, @(questionID), date, @0, @0, answerBody, @(userID), date, @0];
    NSArray* col = @[@"id", @"post_type_id", @"parent_id", @"creation_date", @"score", @"view_count", @"body", @"owner_user_id", @"last_activity_date", @"comment_count"];
    BOOL succeeded = [self insertInto:@"posts" forColumns:col values:args auxiliaryDB:NO];
    
    
    // Query to the auxiliary db so it will be in sync with the SO db
    args = @[@(questionID), [self removeHTMLTags:answerBody]];
    col = @[@"object_id", @"aux_index_string"];
    BOOL auxSucceeded = [self insertInto:@"posts_index" forColumns:col values:args auxiliaryDB:YES];
    
    return succeeded && auxSucceeded;
}

+(BOOL) updateWithCommentText: (NSString *) commentText PostID: (NSInteger) postID ByUser: (NSInteger) userID{
    
    // Current date
    NSString *date = [OPFDateFormatter currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    int id = [OPFDBInsertionIdentifier getNextCommentId];
    
    // Query to the SO db
    NSArray* args = @[@(id), @(postID), @0, commentText, date, @(userID)];
    NSArray* col = @[@"id", @"post_id", @"score", @"text", @"creation_date", @"user_id"];
    
    
    BOOL succeeded = [self insertInto:@"comments" forColumns:col values:args auxiliaryDB:NO];
    
    return succeeded;

}

+(BOOL) updateWithUserName: (NSString *) name EmailHash: (NSString *) email Website: (NSString *) website Location: (NSString *) location Age: (NSInteger) age Bio: (NSString *) bio{
    
    // Current date
    NSString *date = [OPFDateFormatter currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    int id = [OPFDBInsertionIdentifier getNextUserId];
    
    // Query to the SO db
    NSArray* args = @[@(id), @0, date, name, email, date, website, location, @(age), bio, @0, @0, @0];
    NSArray *col = @[@"id", @"reputation", @"creation_date", @"display_name", @"email_hash", @"last_access_date", @"website_url", @"location", @"age", @"about_me", @"views", @"up_votes", @"down_votes"];
    BOOL succeeded = [self insertInto:@"users" forColumns:col values:args auxiliaryDB:NO];
    

    // Query to the auxiliary db to keep it in sync with the SO db
    args = @[@(id), name];
    col = @[@"object_id", @"index_string"];
    BOOL auxSucceeded = [self insertInto:@"users_index" forColumns:col values:args auxiliaryDB:YES];

    return succeeded && auxSucceeded;
}

+(BOOL) updateVoteWithUserID: (NSInteger) userID PostID: (NSInteger) postID Vote: (NSInteger) vote{
    
    __block int voteNum;
    __block int exist;
    
    [[[OPFDatabaseAccess getDBAccess] combinedQueue] inDatabase:^(FMDatabase* db){
        FMResultSet *result = [db executeQuery:@"SELECT COUNT(0) AS existens FROM 'auxDB'.'users_votes' WHERE 'users_votes'.'user_id' = ?" withArgumentsInArray:@[@(userID)]];
        [result next];
        exist = [result intForColumn:@"existens"];
        result = [db executeQuery:@"SELECT * FROM 'auxDB'.'users_votes' WHERE 'users_votes'.'user_id' = ?" withArgumentsInArray:@[@(userID)]];
        [result next];
        voteNum = [result intForColumn:@"upvote"];
    }];
    [[OPFDatabaseAccess getDBAccess] close];
    
    BOOL auxSucceeded;
    
    if(exist==0){
        NSArray *args = @[@(userID),@(postID),@(vote)];
        NSString *auxQuery = [NSString stringWithFormat: @"INSERT INTO users_votes(user_id,post_id,upvote) values (?,?,?);"];
        auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery withArgumentsInArray:args auxiliaryUpdate:YES];
    }
    else{
        NSArray *args = @[@(vote+voteNum),@(userID),@(postID)];
        NSString *auxQuery = [NSString stringWithFormat: @"UPDATE users_votes SET upvote=?  WHERE user_id=? AND post_id=?;"];
        auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery withArgumentsInArray:args auxiliaryUpdate:YES];
    }
    
    NSInteger totalVotes = [[OPFQuestion find:postID].score integerValue]+vote;
    NSArray *args = @[@(totalVotes),@(postID)];
    NSString *query = [NSString stringWithFormat:@"UPDATE posts SET score=? WHERE id=?;"];
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray:args auxiliaryUpdate:NO];

    return auxSucceeded && succeeded;
}

/*// Return current date
+(NSString *) currentDateAsStringWithDateFormat: (NSString *) format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}*/

+(NSString *) removeHTMLTags:(NSString *)input
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<([^<>]+)>" options:0 error:&error];
    NSString* output = [regex stringByReplacingMatchesInString:input options:0 range:NSMakeRange(0, [input length]) withTemplate:@""];
    return output;
}
/*
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

+(int) getNextUserId
{
    __block NSNumber* id;
    [[[OPFDatabaseAccess getDBAccess] combinedQueue] inDatabase:^(FMDatabase* db){
        FMResultSet* result = [db executeQuery:@"SELECT MAX(id) FROM users"];
        if([result next]) {
            id = @([result intForColumnIndex:0]);
        }
    }];
    return [id integerValue] + 1;
}

+(int) getNextCommentId
{
    __block NSNumber* id;
    [[[OPFDatabaseAccess getDBAccess] combinedQueue] inDatabase:^(FMDatabase* db){
        FMResultSet* result = [db executeQuery:@"SELECT MAX(id) FROM comments"];
        if([result next]) {
            id = @([result intForColumnIndex:0]);
        }
    }];
    return [id integerValue] + 1;
}*/

@end