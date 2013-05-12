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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM posts WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    NSString *stringTags;
    
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO posts(id, post_type_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, title, tags, answer_count, comment_count, favorite_count) values (%d, %d, '%@', %d, %d, '%@', %d, '%@', '%@', '%@', %d, %d, %d);", randomID, 1, currentDate, 0, 0, body, userID, currentDate, title, stringTags, 0, 0, 0];
   BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query];
    
    // Temporary code to test if update was as intended
    /*NSString *sql = [NSString stringWithFormat:@"SELECT * FROM posts WHERE title='%@'",title];
    
    FMResultSet *results =  [[OPFDatabaseAccess getDBAccess] executeSQL:sql];
    
    while([results next]) {
        NSString *title = [results stringForColumn:@"title"];
        NSInteger postID  = [results intForColumn:@"id"];
        NSInteger post_type_id  = [results intForColumn:@"post_type_id"];
        NSLog(@"Post ID: %d \nPosttype: %d \ntitle: %@", postID, post_type_id, title);
    }*/
    
    return succeeded;
}

+ (BOOL) updateWithAnswerText: (NSString *) answerBody ByUser: (NSString *) userName UserID: (NSInteger) userID ParentQuestion: (NSInteger) questionID{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM posts WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO posts(id, post_type_id, parent_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, comment_count) values (%d, %d, %d, '%@', %d, %d, '%@', %d, '%@', %d);", randomID, 2, questionID, currentDate, 0, 0, answerBody, userID, currentDate, 0];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query];
    
    // Temporary code to test if update was as intended
    /*NSString *sql = [NSString stringWithFormat:@"SELECT * FROM posts WHERE id=%d",randomID];
     
     FMResultSet *results =  [[OPFDatabaseAccess getDBAccess] executeSQL:sql];
     
     while([results next]) {
         NSString *body = [results stringForColumn:@"body"];
         NSInteger postID  = [results intForColumn:@"id"];
         NSInteger post_type_id  = [results intForColumn:@"post_type_id"];
         NSInteger parent = [results intForColumn:@"parent_id"];
         NSLog(@"Post ID: %d \nPosttype: %d \nParent Question: %d \nbody: %@", postID, post_type_id, parent, body);
     }*/
    
    
    return succeeded;
}

+(BOOL) updateWithCommentText: (NSString *) commentText PostID: (NSInteger) postID ByUser: (NSInteger) userID{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM comments WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO comments(id, post_id, score, text, creation_date, user_id) values (%d,%d,%d,'%@','%@',%d);", randomID, postID, 0, commentText, currentDate, userID];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query];
    
    // Temporary code to test if update was as intended
    /*NSString *sql = [NSString stringWithFormat:@"SELECT * FROM comments WHERE id=%d",randomID];
     
     FMResultSet *results =  [[OPFDatabaseAccess getDBAccess] executeSQL:sql];
     
     while([results next]) {
         NSString *comment = [results stringForColumn:@"text"];
         NSString *creationDate = [results stringForColumn:@"creation_date"];
         NSInteger commentID  = [results intForColumn:@"id"];
         NSInteger post_id  = [results intForColumn:@"post_id"];
     NSLog(@"ID: %d \nPostID: %d \nCreation Date: %@ \nComment: %@", commentID, post_id, creationDate, comment);
     }*/
    
    return succeeded;

}

+(BOOL) updateWithUserName: (NSString *) name EmailHash: (NSString *) email Website: (NSString *) website Location: (NSString *) location Age: (NSInteger) age Bio: (NSString *) bio{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    int randomID = abs(arc4random())%(NSIntegerMax-1);
    
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM users WHERE id=%d",randomID]] next]){
        randomID = arc4random();
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO users(id, reputation, creation_date, display_name, email_hash, last_access_date, website_url, location, age, about_me, views, up_votes, down_votes) values (%d,%d,'%@','%@','%@','%@', '%@', '%@', %d, '%@', '%d', %d, %d);", randomID, 0, currentDate, name, email, currentDate, website, location, age, bio, 0, 0, 0];
    
    
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query];
    
    // Temporary code to test if update was as intended
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM users WHERE id=%d",randomID];
     
     FMResultSet *results =  [[OPFDatabaseAccess getDBAccess] executeSQL:sql];
     
     while([results next]) {
         NSString *name = [results stringForColumn:@"display_name"];
         NSString *creationDate = [results stringForColumn:@"creation_date"];
         NSInteger userID  = [results intForColumn:@"id"];
         NSString *emailhash = [results stringForColumn:@"email_hash"];
         NSLog(@"UserID: %d \nUserName: %@ \nCreation Date: %@ \nE-mail: %@", userID, name, creationDate, emailhash);
     }

    
    return succeeded;
}

@end
