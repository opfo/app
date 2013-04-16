//
//  UserSpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(Foo)

describe(@"foo", ^{
    __block NSString *foo;
    
    beforeEach(^{
        foo = @"foo";
    });
    
    it(@"is an example", ^{
        expect(1).equal(1);
    });
});

SpecEnd