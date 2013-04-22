//
//  OPFInQuerySpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-22.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFInQuery.h"
#import "OPFRootQuery.h"
#import "OPFComment.h"


SpecBegin(OPFInQuery)

describe(@"fetching and SQL-strings", ^{
    __block OPFRootQuery* rootQuery;
    __block OPFQuery* inQuery;
    __block FMResultSet* result;
    
    before(^{
        rootQuery = [OPFComment query];
        inQuery = [rootQuery column:@"score" in: @[@"1", @"2", @(3)]];
    });
    
    it(@"returns correct sql for subquery", ^{
        expect([inQuery toSQLString]).to.equal(@"'comments'.'score' IN (1,2,3)");
    });
    
    it(@"returns the correct amount of objects for the given query", ^{
        result = [inQuery getMany];
        int i = 0;
        while([result next]) {
            i++;
        }
        expect(i).to.equal(2205);
    });
    
    it(@"should work with AND queries", ^{
        [inQuery column:@"user_id" is:@"270"];
        result = [inQuery getMany];
        int i = 0;
        NSDictionary* attributes;
        while ([result next]) {
            i++;
            attributes = [result resultDictionary];
        }
        expect(i).to.equal(1);
        expect([attributes valueForKey:@"id"]).to.equal(@(10395903));
    });
    
    afterEach(^{
        if(result != nil) {
            [result close];
        }
    });
});

SpecEnd