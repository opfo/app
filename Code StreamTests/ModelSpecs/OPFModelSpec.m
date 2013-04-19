//
//  OPFModelSpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-19.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFModelSpecHelper.h"
#import "OPFModel.h"

SpecBegin(OPFModel)

describe(@"Pagination", ^{
    __block NSString *testModelTableName = @"comments";
    
    it(@"should paginate by ten by default", ^{
        FMResultSet* result = [OPFModel allForModel:testModelTableName page: 0];
        NSInteger i = [OPFModelSpecHelper countResult:result];
        expect(i).to.equal([OPFModel defaultPageSize]);
    });
    
    it(@"should support arbitrary pagination", ^{
        FMResultSet* result = [OPFModel allForModel:testModelTableName page:0 per:500];
        NSInteger i = [OPFModelSpecHelper countResult:result];
        expect(i).to.equal(500);
    });
});

SpecEnd