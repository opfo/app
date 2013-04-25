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

describe(@"tag splitting", ^{
    __block NSString* testString1 = @"<mysql><ajax><amazon-web-services><scalability><redundancy>";
    __block NSArray* referenceArray1 = @[@"mysql", @"ajax", @"amazon-web-services", @"scalability", @"redundancy"];
    __block NSString* testString2 = @"<iphone><ios><facebook><facebook-graph-api><facebook-connect>";
    __block NSArray* referenceArray2 = @[@"iphone", @"ios", @"facebook", @"facebook-graph-api", @"facebook-connect"];
    
    it(@"should be able to split the input", ^{
        expect([OPFTag rawTagsToArray:testString1]).to.equal(referenceArray1);
        expect([OPFTag rawTagsToArray:testString2]).to.equal(referenceArray2);
    });
    
    it(@"should be able to transform that shit back", ^{
        expect([OPFTag arrayToRawTags:referenceArray1]).to.equal(testString1);
        expect([OPFTag arrayToRawTags:referenceArray2]).to.equal(testString2);
    });
});

SpecEnd
