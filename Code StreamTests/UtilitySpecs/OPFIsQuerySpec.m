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

describe(@"toSqlString", ^{
    __block OPFRootQuery* rootQuery;
    __block OPFQuery* isQuery;
    
    before(^{
        rootQuery = [OPFComment query];
        isQuery = [rootQuery column:@"score" is:@"1"];
    });
    
    it(@"return correct SQL for subquery", ^(){
        expect([isQuery toSQLString]).to.equal(@"'comments'.'score' = 1");
    });
    
    it(@"returns correct SQL for total query", ^{
        expect([rootQuery toSQLString]).to.equal(@"SELECT 'comments'.* FROM 'comments' WHERE 'comments'.'score' = 1");
    });
});

SpecEnd