//
//  OPFCommentSpec.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFComment.h"

SpecBegin(OPFComment)

describe(@"Model creation", ^{
    __block OPFComment* comment;
    __block NSDictionary* properties = @{@"score": @(9), @"text": @"lorem ipsum", @"creationDate": [NSDate date]};
    __block NSString* commentBody = @"a minute later doesn't make you any less right.";
    
    it(@"should be possible using a dictionary", ^{
        NSError* error;
        comment = [[OPFComment alloc] initWithDictionary: properties error: &error];
        expect(comment).toNot.equal(nil);
        expect(comment.score).to.equal(@(9));
        expect(comment.text).to.equal(properties[@"text"]);
        expect(comment.creationDate).to.equal(properties[@"creationDate"]);
    });
    
    it(@"should be possible using the database", ^{
        OPFComment* comment = [OPFComment find: 8894930];
        expect(comment).toNot.equal(nil);
        expect(comment.text).to.equal(commentBody);
        expect(comment.author_id).to.equal(@(378133));
    });
});

SpecEnd