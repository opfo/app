//
//  OPFUpdateQuery.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-10.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPFUpdateQuery : NSObject

+(BOOL) insertInto: (NSString *) tableName forColumns: (NSArray *) attributes values:(NSArray *) values auxiliaryDB: (BOOL) auxDB;

+ (BOOL)updateVoteWithUserID:(NSInteger)userID postID:(NSInteger)postID vote:(NSInteger)voteState;

+(NSString *) removeHTMLTags: (NSString*) input;
@end
