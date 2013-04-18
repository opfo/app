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
    
    it(@"returns a FMResult", ^{
        FMResultSet* result = [dbAccess executeSQL: sqlString];
        expect(result).notTo.equal(nil);
        [result close];
    });
    
    it(@"returns ten items for the given query", ^{
        FMResultSet* result = [dbAccess executeSQL: sqlString];
        int i = 0;
        while([result next]) {
            i++;
        }
        expect(i).to.equal(10);
        [result close];
    });
    
    it(@"returns the correct amount of columns for the given query", ^{
        FMResultSet* result = [dbAccess executeSQL: sqlString];
        expect([result columnCount]).to.equal(20);
        [result close];
    });
    
    afterAll(^{
        [dbAccess close];
    });
    
    
});

SpecEnd