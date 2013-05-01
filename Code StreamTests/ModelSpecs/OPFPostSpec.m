//
//  OPFPostSpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-05-01.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFModelSpecHelper.h"
#import "OPFPost.h"

SpecBegin(OPFPost)

describe(@"Search", ^{
    it(@"should be possible to perform a simple search", ^{
        NSArray* posts = [[OPFPost searchFor:@"bacon"] getMany];
        expect([posts count]).to.equal(@(1));
    });
});

SpecEnd