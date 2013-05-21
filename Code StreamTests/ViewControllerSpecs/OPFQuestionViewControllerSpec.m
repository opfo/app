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
    
	it(@"should return 5 different and specific cells for the answer question", ^{
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).to.equal(@"PostBodyCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).to.equal(@"PostMetadataCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).to.equal(@"PostTagsCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).to.equal(@"PostCommentsCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]).to.equal(@"AnswerSeparatorCellIdentifier");
	});
	
	it(@"should return 5 different and specific cells for any answer section", ^{
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]).to.equal(@"PostBodyCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]).to.equal(@"PostMetadataCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]]).to.equal(@"PostCommentsCell");
		expect([questionViewController cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]]).to.equal(@"AnswerSeparatorCellIdentifier");
	});
});

SpecEnd