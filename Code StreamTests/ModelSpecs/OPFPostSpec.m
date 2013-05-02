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

@interface OPFPost (Testing)
+(NSString*) tagSearchStringFromArray: (NSArray*) tags;
@end

SpecBegin(OPFPost)

describe(@"Search", ^{
    it(@"should be possible to perform a simple search", ^{
        NSArray* posts = [[OPFPost searchFor:@"bacon"] getMany];
        expect([posts count]).to.equal(@(1));
    });
    
    it(@"should construct a valid tag search string", ^{
        NSArray* tags = @[@"apa", @"bepa", @"cepa"];
        NSString* output = @"%%<apa>%%%%<bepa>%%%%<cepa>%%";
        expect([OPFPost tagSearchStringFromArray:tags]).to.equal(output);
    });
    
    it(@"should be possible to combine tag search with full text", ^{
        NSArray* posts = [[OPFPost searchFor:@"submitting multiple" inTags:@[@"struts2", @"javascript"]] getMany];
        expect(posts.count).to.equal(@(1));
        expect([[posts objectAtIndex: 0] identifier]).to.equal(@(8454965));
    });
});

SpecEnd