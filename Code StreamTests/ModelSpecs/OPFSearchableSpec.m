//
//  OPFSearchableSpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFModelSpecHelper.h"
#import "OPFSearchable.h"

SpecBegin(OPFSearchable)

describe(@"class methods", ^{
    it(@"returns a correct string when constructing queries", ^{
        NSString* input = @"apa bepa cepa";
        NSString* expected = @"index_string:apa index_string:bepa index_string:cepa";
        expect([OPFSearchable matchClauseFromSearchString:input]).to.equal(expected);
    });
});

SpecEnd