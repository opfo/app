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

+ (BOOL)updateVoteWithUserID:(NSInteger)userID postID:(NSInteger)postID vote:(NSInteger)voteState
{
    __block int voteNum;
    __block int exist;
    
    [[[OPFDatabaseAccess getDBAccess] combinedQueue] inDatabase:^(FMDatabase* db){
        FMResultSet *result = [db executeQuery:@"SELECT COUNT(0) AS existens FROM 'auxDB'.'users_votes' WHERE 'users_votes'.'user_id' = ? AND 'users_votes'.'post_id' = ?;" withArgumentsInArray:@[ @(userID), @(postID) ]];
        [result next];
        exist = [result intForColumn:@"existens"];
        result = [db executeQuery:@"SELECT `upvote` FROM 'auxDB'.'users_votes' WHERE 'users_votes'.'user_id' = ? AND 'users_votes'.'post_id' = ?;" withArgumentsInArray:@[ @(userID), @(postID) ]];
        [result next];
        voteNum = [result intForColumn:@"upvote"];
    }];
    [[OPFDatabaseAccess getDBAccess] close];
    
    BOOL auxSucceeded = NO;
    
	NSInteger totalVotes = [OPFQuestion find:postID].score.integerValue;
	
	if (voteState == kOPFPostUserVoteStateNone) {
		NSArray *args = @[ @(userID), @(postID) ];
		NSString *auxQuery = @"DELETE FROM users_votes WHERE 'users_votes'.'user_id' = ? AND 'users_votes'.'post_id' = ?;";
		auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery withArgumentsInArray:args auxiliaryUpdate:YES];
		
		totalVotes -= voteNum;
	} else if (exist == 0) {
        NSArray *args = @[ @(userID), @(postID), @(voteState) ];
        NSString *auxQuery = @"INSERT INTO users_votes(user_id,post_id,upvote) values (?,?,?);";
        auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery withArgumentsInArray:args auxiliaryUpdate:YES];
		
		totalVotes += voteState;
	} else {
		NSArray *args = @[ @(voteState), @(userID), @(postID) ];
		NSString *auxQuery = @"UPDATE users_votes SET upvote=?  WHERE user_id=? AND post_id=?;";
		auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery withArgumentsInArray:args auxiliaryUpdate:YES];
		
		totalVotes = totalVotes - voteNum + voteState;
    }
    
    NSArray *args = @[ @(totalVotes), @(postID) ];
    NSString *query = [NSString stringWithFormat:@"UPDATE posts SET score=? WHERE id=?;"];
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray:args auxiliaryUpdate:NO];

    return auxSucceeded && succeeded;
}

+(NSString *) removeHTMLTags:(NSString *)input
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<([^<>]+)>" options:0 error:&error];
    NSString* output = [regex stringByReplacingMatchesInString:input options:0 range:NSMakeRange(0, [input length]) withTemplate:@""];
    return output;
}
@end