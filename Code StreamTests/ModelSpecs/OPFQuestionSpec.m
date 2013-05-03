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
#import "OPFAnswer.h"

SpecBegin(OPFQuestion)

describe(@"Fetching", ^{
    __block OPFQuestion* question;
    
    beforeEach(^{
        question = [[[OPFQuestion query] whereColumn:@"id" is:@(8414075)] getOne];
    });
    
    it(@"should be possible to do a all-query", ^{
        NSArray* questions = [OPFQuestion all: 30];
        expect(questions.count).to.equal(10);
        for(id question in questions) {
            expect(question).to.beKindOf([OPFQuestion class]);
        }
    });
    
    it(@"should not fetch an incorrect type of model", ^{
        question = [[[OPFQuestion query] whereColumn: @"id" is: @"8474693"] getOne];
        expect(question).to.beNil();
    });
    
    it(@"should fetch an object of the correct type", ^{
        expect(question).to.beKindOf([OPFQuestion class]);
    });
    
    it(@"should be possible to get the accepted answer", ^{
        expect(question.acceptedAnswer).to.beKindOf([OPFAnswer class]);
    });
    
    it(@"should be possible to get all answers", ^{
        NSArray* answers = question.answers;
        expect([answers count]).to.equal(2);
        for(id answer in answers) {
            expect(answer).to.beKindOf([OPFAnswer class]);
        }
    });
    
    it(@"should load the correct tags", ^{
        question = [[[OPFQuestion query] whereColumn:@"id" is:@(8414337)] getOne];
        NSArray* reference = @[@"iphone", @"ios", @"facebook", @"facebook-graph-api", @"facebook-connect"];
        expect(question.tags).to.beKindOf([NSArray class]);
        expect([question.tags count]).equal([reference count]);
        expect(question.tags).to.equal(reference);
    });
    
    it(@"should load correct property types", ^{
        question = [[[OPFQuestion query] whereColumn:@"id" is:@(8473230)] getOne];
        expect(question.closedDate).beKindOf([NSDate class]);
    });
});

describe(@"searching", ^{
    it(@"should return only question objects", ^{
        NSArray* questions = [[OPFQuestion searchFor:@"division"] getMany];
        expect(questions.count).to.beGreaterThan(@(0));
        for(id q in questions){
            expect(q).to.beKindOf([OPFQuestion class]);
        }
    });
    
    describe(@"searching for tags", ^{
        it(@"should be possible to search questions by tags", ^{
            NSArray* questions = [[OPFQuestion withTags:@[@"playframework"]] getMany];
            expect(questions.count).to.equal(@(10));
        });
        
        it(@"should be possible to combine tags", ^{
            NSArray* questions = [[OPFQuestion withTags:@[@"playframework", @"jobs"]] getMany];
            expect(questions.count).to.equal(@(1));
        });
    });
});

SpecEnd