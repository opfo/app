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
    
    // Calculate random and unique id for post
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM posts WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    
    // Query for the SO db
    NSString *query = [NSString stringWithFormat:@"INSERT INTO posts(id, post_type_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, title, tags, answer_count, comment_count, favorite_count) values (%d, %d, '%@', %d, %d, '%@', %d, '%@', '%@', '%@', %d, %d, %d);", randomID, 1, date, 0, 0, body, userID, date, title, tags, 0, 0, 0];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query auxiliaryUpdate:NO];
    
    // Update the auxiliary db so it become in sync with the SO db
    NSString *auxQuery = [NSString stringWithFormat: @"INSERT INTO posts_index(object_id, main_index_string, aux_index_string, tags) values (%d, '%@', '%@', '%@');",randomID, body, @"" ,tags];
    
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery auxiliaryUpdate:YES];
    
    // Update corresponding tag column in auxiliary db. Imcomplete implementation
/*  NSString *strippedTagsString = [tags stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strippedTagsString = [strippedTagsString stringByReplacingOccurrencesOfString:@">" withString:@" "];
    NSMutableArray *tagsArray = [[strippedTagsString componentsSeparatedByString:@" "] mutableCopy];
    [tagsArray removeLastObject];
    
    BOOL tagAuxUpdate = NO;
    for(NSString *tag __strong in tagsArray){
        if(![tag isEqualToString:@" "]){
            NSString *auxTagQuery = [NSString stringWithFormat: @"INSERT INTO tags(name, counter) values ('%@',%d);",tag, 0];
            tagAuxUpdate = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxTagQuery auxiliaryUpdate:YES];
        }
    }*/
    
    return (succeeded && auxSucceeded) ? randomID : 0;
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
    NSString *query = [NSString stringWithFormat:@"INSERT INTO posts(id, post_type_id, parent_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, comment_count) values (%d, %d, %d, '%@', %d, %d, '%@', %d, '%@', %d);", randomID, 2, questionID, date, 0, 0, answerBody, userID, date, 0];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query auxiliaryUpdate:NO];
    
    // Query to the auxiliary db so it will be in sync with the SO db
    NSString *auxQuery = [NSString stringWithFormat: @"INSERT INTO posts_index(object_id, main_index_string) values (%d, '%@');",randomID, answerBody];
    
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
    NSString *query = [NSString stringWithFormat:@"INSERT INTO comments(id, post_id, score, text, creation_date, user_id) values (%d,%d,%d,'%@','%@',%d);", randomID, postID, 0, commentText, date, userID];
    
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
    NSString *query = [NSString stringWithFormat:@"INSERT INTO users(id, reputation, creation_date, display_name, email_hash, last_access_date, website_url, location, age, about_me, views, up_votes, down_votes) values (%d,%d,'%@','%@','%@','%@', '%@', '%@', %d, '%@', '%d', %d, %d);", randomID, 0, date, name, email, date, website, location, age, bio, 0, 0, 0];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query auxiliaryUpdate:NO];
    
    // Query to the auxiliary db to keep it in sync with the SO db
    NSString *auxQuery = [NSString stringWithFormat: @"INSERT INTO users_index(object_id, index_string) values (%d, '%@');",randomID, name];
    BOOL auxSucceeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:auxQuery auxiliaryUpdate:YES];

    return succeeded && auxSucceeded;
}

// Return current date
-(NSString *) currentDateAsStringWithDateFormat: (NSString *) format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
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
