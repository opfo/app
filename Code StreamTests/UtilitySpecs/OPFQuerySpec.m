//
//  OPFQuerySpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFQuery.h"
#import "OPFComment.h"


SpecBegin(OPFQuery)

describe(@"Creation", ^(){
    it(@"should be possible from a model", ^{
        OPFQuery* query = [OPFComment query];
        expect(query).to.beKindOf([OPFQuery class]);
    });
});

describe(@"Root query", ^(){
    __block OPFQuery* query;
    __block OPFQuery* secondQuery;
    before(^{
        query = [OPFComment query];
    });
    it(@"should return it self when top query ", ^(){
        expect([query rootQuery]).to.equal(query);
    });
    it(@"should return the root query for a subquery", ^{
        secondQuery = [query whereColumn: @"score" is: @"1"];
        expect(secondQuery).notTo.beNil();
        expect(secondQuery.rootQuery).to.equal(query);
    });
});

SpecEnd