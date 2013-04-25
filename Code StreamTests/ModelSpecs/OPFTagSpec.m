//
//  OPFTagSpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-25.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFModelSpecHelper.h"
#import "OPFTag.h"

SpecBegin(OPFTag)

describe(@"Fetching", ^{
    __block OPFTag* tag;
    
    beforeEach(^{
        tag = [[[OPFTag query] whereColumn:@"id" is: @(1)] getOne];
    });
    it(@"should return a tag", ^{
        expect(tag).to.beKindOf([OPFTag class]);
    });
    it(@"should return the correct tag", ^{
        expect(tag.name).to.equal(@"mysql");
    });
    
    it(@"can fetch related questions", ^{
        expect([tag.questions count]).to.equal(147);
    });
    
});

SpecEnd
