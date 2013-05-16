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

@implementation OPFUpdateQuery

+(BOOL) updateWithQuestionTitle: (NSString *) title Body: (NSString *) body Tags: (NSString *) tags ByUser: (NSString *) userName userID: (NSInteger) userID{
    
    // Current date
    NSString *date = [self currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    // Calculate random and unique id for post
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM posts WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    
    // Query for the SO db
    NSString *query = [NSString stringWithFormat:@"INSERT INTO posts(post_type_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, title, tags, answer_count, comment_count, favorite_count) values (%d, '%@', %d, %d, '%@', %d, '%@', '%@', '%@', %d, %d, %d);", 1, date, 0, 0, body, userID, date, title, tags, 0, 0, 0];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query auxiliaryUpdate:NO];
    
    // Update the auxiliary db so it become in sync with the SO db
    NSString *auxQuery = [NSString stringWithFormat: @"INSERT INTO posts_index(main_index_string, aux_index_string, tags) values ('%@', '%@', '%@');",body, @"" ,tags];
    
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery auxiliaryUpdate:YES];
    
    return (succeeded && auxSucceeded);
}

+ (NSInteger) updateWithAnswerText: (NSString *) answerBody ByUser: (NSString *) userName UserID: (NSInteger) userID ParentQuestion: (NSInteger) questionID{
    
    // Current date
    NSString *date = [self currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    // Calculate a random and unique id for post
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM posts WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    
    // Query to the SO db
    NSString *query = [NSString stringWithFormat:@"INSERT INTO posts(post_type_id, parent_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, comment_count) values (%d, %d, '%@', %d, %d, '%@', %d, '%@', %d);", 2, questionID, date, 0, 0, answerBody, userID, date, 0];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query auxiliaryUpdate:NO];
    
    // Query to the auxiliary db so it will be in sync with the SO db
    NSString *auxQuery = [NSString stringWithFormat: @"INSERT INTO posts_index(main_index_string) values ('%@');",answerBody];
    
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery auxiliaryUpdate:YES];
    
    return succeeded && auxSucceeded ? randomID:0;
}

+(NSInteger) updateWithCommentText: (NSString *) commentText PostID: (NSInteger) postID ByUser: (NSInteger) userID{
    
    // Current date
    NSString *date = [self currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    // Calculate a random and unique id for comment
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM comments WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    
    // Query to the SO db
    NSString *query = [NSString stringWithFormat:@"INSERT INTO comments(post_id, score, text, creation_date, user_id) values (%d,%d,'%@','%@',%d);",postID, 0, commentText, date, userID];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query auxiliaryUpdate:NO];
    
    return succeeded ? randomID:0;

}

+(BOOL) updateWithUserName: (NSString *) name EmailHash: (NSString *) email Website: (NSString *) website Location: (NSString *) location Age: (NSInteger) age Bio: (NSString *) bio{
    
    // Current date
    NSString *date = [self currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    
    // Create a random and unique id for the user
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM users WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    
    // Query to the SO db
    NSString *query = [NSString stringWithFormat:@"INSERT INTO users(reputation, creation_date, display_name, email_hash, last_access_date, website_url, location, age, about_me, views, up_votes, down_votes) values (%d,'%@','%@','%@','%@', '%@', '%@', %d, '%@', '%d', %d, %d);",0, date, name, email, date, website, location, age, bio, 0, 0, 0];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query auxiliaryUpdate:NO];
    

    // Query to the auxiliary db to keep it in sync with the SO db
    NSString *auxQuery = [NSString stringWithFormat: @"INSERT INTO users_index(index_string) values ('%@');",name];
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery auxiliaryUpdate:YES];

    return succeeded && auxSucceeded;
}

+(BOOL) updateVoteWithUserID: (NSInteger) userID PostID: (NSInteger) postID Vote: (NSInteger) vote{
    NSString *auxQuery = [NSString stringWithFormat: @"INSERT INTO users_votes(user_id,post_id,upvote) values (%d,%d,%d);",userID,postID,vote];
    
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery auxiliaryUpdate:YES];
    
    NSInteger totalVotes = [[OPFQuestion find:postID].score integerValue]+vote;
    
    NSString *query = [NSString stringWithFormat:@"UPDATE posts SET score=%d WHERE id=%d;",totalVotes,postID];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query auxiliaryUpdate:NO];
    
    OPFPost *post = [OPFPost find:postID];
    
    FMResultSet *result = [[OPFDatabaseAccess getDBAccess] executeSQL:@"SELECT * FROM posts WHERE id=postID"];
    
    NSLog(@"Score: %d for query: %@", [result intForColumnIndex:5],query);
    
    return auxSucceeded && succeeded;
}

// Return current date
+(NSString *) currentDateAsStringWithDateFormat: (NSString *) format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end

