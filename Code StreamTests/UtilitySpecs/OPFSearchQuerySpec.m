//
//  OPFSearchQuerySpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFModelSpecHelper.h"
#import "OPFPost.h"

SpecBegin(OPFSearchQuery)

describe(@"searching", ^{
    it(@"should be possible", ^{
        NSArray* posts = [[OPFPost searchFor:@"bacon"] getMany];
        expect([posts count]).to.equal(@(1));
    });
    
    describe(@"combined with other statements", ^{
        NSArray* posts = [[[OPFPost searchFor: @"injection"] page:0] getMany];
        expect([posts count]).to.equal([OPFPost defaultPageSize]);
        expect([[posts objectAtIndex:0] identifier]).to.equal(@(8414287));
        expect([[posts objectAtIndex:9] identifier]).to.equal(@(8469386));
    });
});
SpecEnd