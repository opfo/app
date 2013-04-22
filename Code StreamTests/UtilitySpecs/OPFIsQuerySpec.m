//
//  OPFIsQuerySpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-22.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFIsQuery.h"
#import "OPFRootQuery.h"
#import "OPFComment.h"


SpecBegin(OPFIsQuery)

describe(@"fetching and SQL-strings", ^{
    __block OPFRootQuery* rootQuery;
    __block OPFQuery* isQuery;
    
    before(^{
        rootQuery = [OPFComment query];
        isQuery = [rootQuery whereColumn:@"score" is:@"1"];
    });
    
    it(@"returns correct SQL for subquery", ^(){
        expect([isQuery toSQLString]).to.equal(@"'comments'.'score' = 1");
    });
    
    it(@"returns correct SQL for total query", ^{
        expect([rootQuery toSQLString]).to.equal(@"SELECT 'comments'.* FROM 'comments' WHERE 'comments'.'score' = 1");
    });
    
    it(@"fetches correct number of results when fetching multiple", ^{
        FMResultSet* result = [isQuery getMany];
        int i = 0;
        while ([result next]) {
            i++;
        }
        expect(i).to.equal(1620);
    });
    
    it(@"fetches correct object for for a single object query", ^{
        isQuery = [rootQuery whereColumn: @"user_id" is: @"270"];
        FMResultSet* result = [isQuery getOne];
        NSDictionary* attributes;
        int i = 0;
        while([result next]) {
            attributes = [result resultDictionary];
            i++;
        }
        expect(i).to.equal(1);
        expect([attributes valueForKey:@"id"]).to.equal(@(10395903));
    });
    
    it(@"returns correct SQL for an and-query", ^{
        OPFIsQuery* secondQuery = [isQuery whereColumn:@"post_id" is:@"1"];
        expect([rootQuery toSQLString])
            .to
            .equal(@"SELECT 'comments'.* FROM 'comments' WHERE ('comments'.'score' = 1 AND 'comments'.'post_id' = 1)");
    });
});

SpecEnd