//
//  OPFUpdateQuery.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-10.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPFUpdateQuery : NSObject

+(BOOL) updateWithQuestionTitle: (NSString *) title Body: (NSString *) body Tags: (NSString *) tags ByUser: (NSString *) userName userID: (NSInteger) userID;

+(BOOL) updateWithAnswerText: (NSString *) answerBody ByUser: (NSString *) userName UserID: (NSInteger) userID ParentQuestion: (NSInteger) questionID;

+(BOOL) updateWithCommentText: (NSString *) commentText PostID: (NSInteger) postID ByUser: (NSInteger) userID;
@end
