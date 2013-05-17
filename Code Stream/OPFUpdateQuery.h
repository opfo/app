//
//  OPFUpdateQuery.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-10.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPFUpdateQuery : NSObject

// Update database with new question
+(BOOL) updateWithQuestionTitle: (NSString *) title Body: (NSString *) body Tags: (NSString *) tags ByUser: (NSString *) userName userID: (NSInteger) userID;

// Update database with new answer
+(BOOL) updateWithAnswerText: (NSString *) answerBody ByUser: (NSString *) userName UserID: (NSInteger) userID ParentQuestion: (NSInteger) questionID;

// Update database with new comment
+(BOOL) updateWithCommentText: (NSString *) commentText PostID: (NSInteger) postID ByUser: (NSInteger) userID;

// Update database with new user
+(BOOL) updateWithUserName: (NSString *) name EmailHash: (NSString *) email Website: (NSString *) website Location: (NSString *) location Age: (NSInteger) age Bio: (NSString *) bio;

+ (BOOL)updateVoteWithUserID:(NSInteger)userID postID:(NSInteger)postID vote:(NSInteger)voteState;

+(NSString *) currentDateAsStringWithDateFormat:(NSString *) format;

+(NSString *) removeHTMLTags: (NSString*) input;

+(int) getNextPostId;
@end
