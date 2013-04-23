//
//  OPFAnswerSpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-23.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFModelSpecHelper.h"
#import "OPFQuestion.h"
#import "OPFAnswer.h"

SpecBegin(OPFAnswer)

describe(@"Fetching", ^{
    __block OPFAnswer* answer;
    
    beforeEach(^{
        answer = [[[OPFAnswer query] whereColumn:@"id" is:@(8474366)] getOne];
    });
    it(@"should not fetch an incorrect type of model", ^{
        answer = [[[OPFAnswer query] whereColumn: @"id" is: @(8414076)] getOne];
        expect(answer).to.beNil();
    });
    
    it(@"should fetch an object of the correct type", ^{
        expect(answer).to.beKindOf([OPFAnswer class]);
    });
    
    it(@"should be able to fetch the connected question", ^{
        expect(answer.parent).notTo.beNil();
        expect(answer.parent).to.beKindOf([OPFQuestion class]);
        expect(answer.parent.identifier).to.equal(answer.parentId);
    });
    
});

SpecEnd