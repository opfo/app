//
//  OPFQuestionViewControllerSpec
//  Code Stream
//
//  Created by Aron Cedercrantz on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFQuestionViewController.h"

@interface OPFQuestionViewController (/*Private*/)
- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath;
@end

SpecBegin(OPFQuestionViewController)

describe(@"cellIdentifierForIndexPath:", ^{
    OPFQuestionViewController *questionViewController = [OPFQuestionViewController new];
    
    it(@"should return BodyCellIdentifier (PostBodyCell) for the first row in any section", ^{
        expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).to.equal(@"PostBodyCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:0 inSection:124]]).to.equal(@"PostBodyCell");
    });
	
	it(@"should return MetadataCellIdentifier (PostMetadataCell) for the second row in any section", ^{
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).to.equal(@"PostMetadataCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:1 inSection:142]]).to.equal(@"PostMetadataCell");
	});
	
	it(@"should return TagsCellIdentifier (PostTagsCell) for the the third row in a question post (first section)", ^{
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).to.equal(@"PostTagsCell");
	});
	
	it(@"should return CommentsCellIdentifier (PostCommentsCell) for the fourth row in a question post (first section)", ^{
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).to.equal(@"PostCommentsCell");
	});
	
	it(@"should return CommentsCellIdentifier (PostCommentsCell) for the third row for any section except the question post", ^{
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]]).to.equal(@"PostCommentsCell");
	});
	
	it(@"should not return TagsCellIdentifier (PostTagsCell) for the third row in a answer post", ^{
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]]).toNot.equal(@"PostTagsCell");
	});
	
	it(@"should return nil if the index path does not match any known identifier", ^{
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]]).to.equal(nil);
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]]).to.equal(nil);
	});
});

SpecEnd