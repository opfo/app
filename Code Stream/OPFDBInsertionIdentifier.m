//
//  OPFDBInsertionIdentifier.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-19.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFDBInsertionIdentifier.h"
#import "OPFDatabaseAccess.h"

@implementation OPFDBInsertionIdentifier
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
}

@end
