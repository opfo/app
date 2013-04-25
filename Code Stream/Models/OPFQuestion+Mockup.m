//
//  OPFQuestion+Mockup.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-19.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestion+Mockup.h"
#import "OPFAnswer.h"
#import <objc/runtime.h>

@implementation OPFQuestion (Mockup)

static const void *kOPFQuestionMockupTagsKey;

// Added by <gothm> for testing. Delete / move at will
+ (id)generatePlaceholderQuestion {
	OPFQuestion *question = [OPFQuestion new];
	
	
	// 50-50 chance of having an accepted answer
	question.acceptedAnswer = (arc4random() % 2 == 0) ? [OPFAnswer new] : nil;
	
	// Create random integers
	question.answerCount = @(arc4random() % 100);
	question.score = @(arc4random() % 1500);
	question.viewCount = @(arc4random() % 2300);
	question.title = @"Is this a question that contains a line break or not?";
	question.body = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
	question.commentCount = @(arc4random() % 8);
	question.favoriteCount = @(arc4random() % 30);
	
	// Create random dates earlier than 13-04-18
	question.closedDate = [NSDate dateWithTimeIntervalSince1970: arc4random() % 1366296511];
	question.lastEditDate = [NSDate dateWithTimeIntervalSince1970: arc4random() % 1366296511];
	question.lastActivityDate = [NSDate dateWithTimeIntervalSince1970: arc4random() % 1366296511];
	question.communityOwnedDate = [NSDate dateWithTimeIntervalSince1970: arc4random() % 1366296511];
	
	// Tags
	NSArray *tags = (arc4random() % 4 != 0 ? (arc4random() % 2 == 0 ? @[ @"java", @"objective-c" ] : @[ @"git", @"version-control" ]) : @[ @"c" ]);
	objc_setAssociatedObject(question, kOPFQuestionMockupTagsKey, tags, OBJC_ASSOCIATION_COPY_NONATOMIC);
	
	return question;
}

- (NSArray *)tags
{
	NSArray *tags = objc_getAssociatedObject(self, kOPFQuestionMockupTagsKey);
	return tags;
}

@end
