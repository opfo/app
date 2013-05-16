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
    
    
    it(@"should be possible to combine tag search with full text", ^{
        NSArray* posts = [[OPFPost searchFor:@"submitting multiple" inTags:@[@"struts2", @"javascript"]] getMany];
        expect(posts.count).to.equal(@(1));
        expect([[posts objectAtIndex: 0] identifier]).to.equal(@(8454965));
    });
});

//describe(@"Saving", ^{
//    it(@"should serialize it self correctly", ^{
//        OPFPost* post = [OPFPost find: 8418025];
//        MTLJSONAdapter* adapter = [[MTLJSONAdapter alloc] initWithModel:post];
//        NSDictionary* attrs = [adapter JSONDictionary];
//            NSDictionary* expected = @{             @"id": @8418025,
//                                                    @"creation_date": @"2011-12-07",
//                                                    @"post_type_id": @1,
//                                                    @"score": @1,
//                                                    @"view_count": @65,
//                                                    @"title": [NSNull null],
//                                                    @"body": @"<p>Without jailbreak you can not.</p>\n",
//                                                    @"owner_user_id": @498796,
//                                                    @"last_editor_user_id": [NSNull null],
//                                                    @"last_editor_display_name": [NSNull null],
//                                                    @"last_edit_date": @"[NSNull null]",
//                                                    @"last_activity_date": @"2011-12-07",
//                                                    @"community_owned_date": [NSNull null],
//                                                    @"comment_count": @3,
//                                                    @"favorite_count": [NSNull null],
//                                                    @"closed_date": [NSNull null],
//                                                    @"accepted_answer_id": [NSNull null],
//                                                    @"tags": [NSNull null],
//                                                    @"answer_count": [NSNull null],
//                                                    @"parent_id": @8417967};
//        expect(attrs).to.equal(expected);
//    });
//});

SpecEnd