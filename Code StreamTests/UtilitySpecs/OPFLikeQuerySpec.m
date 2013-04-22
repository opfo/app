//
//  OPFLikeQuerySpec.m
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


SpecBegin(OPFLikeQuery)

describe(@"fetching and SQL-strings", ^{
    __block OPFRootQuery* rootQuery;
    __block OPFQuery* inQuery;
    __block FMResultSet* result;
    
    before(^{
        rootQuery = [OPFComment query];
        inQuery = [rootQuery whereColumn:@"text" like: @"%%CSS%%"];
    });
    
    it(@"returns correct sql for subquery", ^{
        expect([inQuery toSQLString]).to.equal(@"'comments'.'text' LIKE '%%CSS%%'");
    });
    
    it(@"returns the correct amount of objects for the given query", ^{
        result = [inQuery getMany];
        int i = 0;
        while([result next]) {
            i++;
        }
        expect(i).to.equal(140);
    });
    
    afterEach(^{
        if(result != nil) {
            [result close];
        }
    });
});

SpecEnd
