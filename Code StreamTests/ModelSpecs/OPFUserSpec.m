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
#import "OPFUser.h"
#include <objc/runtime.h>

SpecBegin(OPFUser)

describe(@"User creation", ^{
    __block OPFUser* user;
    __block NSDictionary* properties = @{@"reputation": @(9), @"displayName": @"lorem ipsum", @"creationDate": [NSDate date]};
    __block NSDictionary* correctProperties
        = @{
            @"identifier": @42,
            @"reputation": @9060,
            @"creationDate": @"2008-08-01",
            @"displayName": @"Coincoin",
            @"emailHash": @"621f5ee6cf6e295d1b5fa45bde67c803",
            @"lastAccessDate": @"2012-07-30",
            @"location": @"Montreal, Canada",
            @"age": @32,
            @"downVotes": @37,
            @"upVotes": @297
            };
    
    it(@"should be possible using a dictionary", ^{
        NSError* error;
        user = [[OPFUser alloc] initWithDictionary: properties error: &error];
        expect(user).toNot.equal(nil);
        expect(user.reputation).to.equal(@(9));
        expect(user.displayName).to.equal(properties[@"displayName"]);
        expect(user.creationDate).to.equal(properties[@"creationDate"]);
    });
    
    it(@"should be possible using the database", ^{
        user = [OPFUser find: 42];
        expect(user.displayName).to.equal(@"Coincoin");
    });
    
    it(@"should have all wanted attributes when fetched from the DB", ^{
        user = [OPFUser find: 42];
        for(NSString* key in correctProperties) {
            expect([user valueForKey:key]).to.equal([correctProperties valueForKey: key]);
        }
    });
});

describe(@"Pagination", ^{
    it(@"should paginate by ten by default", ^{
        NSArray* result = [OPFUser all:0];
        expect([result count]).to.equal([OPFModel defaultPageSize]);
        expect([[result objectAtIndex:0] identifier]).to.equal(@(13));
    });
    
    it(@"should support arbitrary pagination", ^{
        NSArray* result = [OPFUser all:0 per: 500];
        expect([result count]).to.equal(500);
    });
});

SpecEnd