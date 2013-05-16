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
#import "OPFAnswer.h"
#import "OPFComment.h"
#include <objc/runtime.h>

SpecBegin(OPFUser)

describe(@"User creation", ^{
    __block OPFUser* user;
    __block NSDictionary* properties = @{@"reputation": @(9), @"displayName": @"lorem ipsum", @"creationDate": [NSDate date]};
    
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
    
});

describe(@"user fetching", ^{
    __block OPFUser* user;
    
    beforeEach(^{
        user = [[[OPFUser query] whereColumn:@"id" is: @(13)] getOne];
    });
    
    it(@"has the correct url", ^{
        expect(user.websiteUrl).to.beKindOf([NSURL class]);
        expect(user.websiteUrl).to.equal([NSURL URLWithString:@"http://about.me/cky"]);
    });
    
    it (@"has correct types", ^{
        expect(user.creationDate).to.beKindOf([NSDate class]);
        expect(user.lastAccessDate).to.beKindOf([NSDate class]);
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

describe(@"display name search", ^{
    it(@"is possible to search users by display name", ^{
        NSArray* users = [[OPFUser searchFor:@"roryf"] getMany];
        expect([users count]).to.beGreaterThan(0);
        expect([[users objectAtIndex:0] identifier]).to.equal(@(270));
        users = [[OPFUser searchFor:@"matt"] getMany];
        expect([users count]).to.equal(37);
        expect([[users objectAtIndex:0] identifier]).to.equal(@(797));
        expect([[users objectAtIndex:36] identifier]).to.equal(@(1091105));
    });
    
    it(@"should be possible to find Bryan Lyttle", ^{
        NSArray* users = [[OPFUser searchFor:@"brian lyttle"] getMany];
        expect(users.count).to.equal(1);
        OPFUser* user = [users objectAtIndex:0];
        expect(user.displayName).to.equal(@"Brian Lyttle");
        expect(user.downVotes).to.equal(@(153));
        expect(user.reputation).to.equal(@(7174));
    });
});

describe(@"fetching related objects", ^{
    __block OPFUser *user = [OPFUser find: 22656];
    __block OPFUser *userWithQuestions = [OPFUser find: 1127616];
    it(@"is possible to fetch answers", ^{
        NSArray* answers = [[user answers] getMany];
        expect(answers.count).to.equal(21);
        for (id answer in answers) {
            expect([answer ownerId]).to.equal(user.identifier);
        }
    });
    
    it(@"is possible to fetch all questions", ^{
        NSArray* questions = [[userWithQuestions questions] getMany];
        expect(questions.count).to.equal(3);
        for(id question in questions) {
            expect([question ownerId]).to.equal(userWithQuestions.identifier);
        }
    });
    
    it(@"is possible to get all comments", ^{
        NSArray* comments = [[user comments] getMany];
        expect([comments count]).to.equal(@(37));
        for(id c in comments) {
            expect(c).to.beKindOf([OPFComment class]);
        }
    });
});

describe(@"equals and hash", ^{
    __block OPFUser *userWithQuestions = [OPFUser find: 1127616];
    __block OPFUser *sameUser = [OPFUser find: 1127616];
    it(@"should be possible to do equals without stuff exploding in your face", ^{
        expect([userWithQuestions isEqual:sameUser]).to.beTruthy();
    });
    
    it(@"should be possible to do hash without stuff exploding in your face", ^{
        expect([userWithQuestions hash]).to.equal([[OPFUser modelTableName] hash] + [userWithQuestions.identifier integerValue]);
    });
});

SpecEnd