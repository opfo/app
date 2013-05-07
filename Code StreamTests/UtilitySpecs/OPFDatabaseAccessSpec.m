//
//  OPFDatabaseAccessSpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFDatabaseAccess.h"

SpecBegin(OPFDatabaseAccess)

describe(@"executing SQL", ^{
    __block OPFDatabaseAccess* dbAccess = [OPFDatabaseAccess getDBAccess];
    __block NSString* sqlString = @"SELECT 'posts'.* FROM 'posts' LIMIT 10";
    __block FMResultSet* result;
    
    it(@"returns a FMResult", ^{
        result = [dbAccess executeSQL: sqlString];
        expect(result).notTo.equal(nil);
        [result close];
    });
    
    it(@"returns ten items for the given query", ^{
        result = [dbAccess executeSQL: sqlString];
        int i = 0;
        while([result next]) {
            i++;
        }
        expect(i).to.equal(10);
        [result close];
    });
    
    it(@"returns the correct amount of columns for the given query", ^{
        result = [dbAccess executeSQL: sqlString];
        expect([result columnCount]).to.equal(20);
        [result close];
    });
    
    it(@"should be possible to query both dbs using the combined queue", ^{
        [dbAccess.combinedQueue inDatabase:^(FMDatabase* db){
            result = [db executeQuery:@"SELECT COUNT(*) as cnt FROM 'auxDB'.'posts_index'"];
        }];
        expect([result next]).beTruthy();
        expect([result intForColumn:@"cnt"]).to.equal(13092);
        result = [dbAccess executeSQL:@"SELECT object_id FROM auxDB.posts_index WHERE main_index_string MATCH 'bacon'"];
        expect([result next]).to.beTruthy();
        [result close];
    });
    
    it(@"should be possible to do a combined queue query using the convience method", ^{
        result = [dbAccess executeSQL:@"SELECT object_id FROM auxDB.posts_index WHERE main_index_string MATCH 'bacon'"];
        expect([result next]).to.beTruthy();
        expect([result intForColumn:@"object_id"]).to.equal(8470957);
        [result close];
    });
    afterAll(^{
        [dbAccess close];
    });
    
});

SpecEnd