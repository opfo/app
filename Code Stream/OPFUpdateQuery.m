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
    
    while([[[OPFDatabaseAccess getDBAccess] executeSQL:[NSString stringWithFormat:@"SELECT id FROM Posts WHERE id=%d",randomID]] next]){
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

@end
