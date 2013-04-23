//
//  OPFQuestionSpec.m
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

SpecBegin(OPFQuestion)

describe(@"Fetching", ^{
    it(@"should not fetch an incorrect type of model", ^{
        id question = [[[OPFQuestion query] whereColumn: @"id" is: @"8474693"] getOne];
        expect(question).to.beNil();
    });
    
    it(@"should fetch an object of the correct type", ^{
        id question = [[[OPFQuestion query] whereColumn:@"id" is: @(8414075)] getOne];
        expect(question).to.beKindOf([OPFQuestion class]);
    });
});

SpecEnd