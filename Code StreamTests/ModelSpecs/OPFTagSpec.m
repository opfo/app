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

describe(@"get tags by name", ^{
    it(@"should return the correct tag", ^{
        OPFTag* tag = [OPFTag byName:@"mysql"];
        expect(tag.identifier).to.equal(@(1));
    });
});

describe(@"get related tags", ^{
    __block NSArray* tags = [OPFTag relatedTagsForTagWithName:@"css"];
    it(@"should number 10", ^{
        expect(tags.count).to.equal(@(10));
    });
    
    it(@"should be OPFTags", ^{
        expect(tags.count).notTo.equal(0);
        for(id object in tags) {
            expect(object).to.beKindOf([OPFTag class]);
        }
    });
    
    it(@"should have the correct tags", ^{
        NSArray* expected = @[@"html", @"jquery", @"javascript", @"css3",@"internet-explorer", @"css-float", @"internet-explorer-7", @"html5", @"div", @"firefox"];
        for(int i = 0; i < expected.count; i++) {
            expect([[tags objectAtIndex: i] name]).to.equal([expected objectAtIndex:i]);
        }
    });
});

describe(@"most common tags", ^{
    __block NSArray* tags = [OPFTag mostCommonTags];
    it(@"should get correct tags", ^{
        NSArray* expected = @[
                              @"android",
                              @"java",
                              @"c#",
                              @"javascript",
                              @"php",
                              @"jquery",
                              @"ios",
                              @"c++",
                              @"iphone",
                              @"asp.net",
                              @"html",
                              @"python",
                              @"mysql",
                              @"css",
                              @"objective-c",
                              @".net",
                              @"sql",
                              @"ruby-on-rails",
                              @"c",
                              @"ruby"];
        expect(tags.count).to.equal(kOPFPopularTagsLimit);
        for(int i = 0; i < tags.count; i++) {
            expect([[tags objectAtIndex:i] name]).to.equal([expected objectAtIndex:i]);
        }
    });
});

SpecEnd
