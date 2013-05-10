//
//  OPFUpdateQuery.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-10.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUpdateQuery.h"
#import "OPFDatabaseAccess.h"

@implementation OPFUpdateQuery

-(BOOL) updateWithQuestionTitle: (NSString *) title Body: (NSString *) body Tags: (NSArray *) tags ByUser: (NSString *) userName userID: (NSInteger) userID{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger postID = 0;
    NSString *stringTags;
    
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO posts(id, post_type_id, creation_date, score, view_count, body, owner_user_id, last_activity_date, title, tags, answer_count, comment_count, favorite_count) values (%d, %d, '%@', %d, %d, '%@', %d, '%@', '%@', '%@', %d, %d, %d);", postID, 1, currentDate, 0, 0, body, userID, currentDate, title, stringTags, 0, 0, 0];
    
    
    return [[OPFDatabaseAccess getDBAccess] executeUpdate:query];
}

@end
