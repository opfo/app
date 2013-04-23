//
//  OPFQuestion.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPost.h"
@class OPFAnswer;

@interface OPFQuestion : OPFPost

@property (strong, readonly) NSArray* tags;
@property (strong) OPFAnswer* acceptedAnswer;
@property (strong) NSNumber* acceptedAnswerId;
@property (strong) NSDate* closedDate;
@property (strong) NSNumber* answerCount;
@property (strong, readonly) NSArray* answers;
@property (copy) NSString* rawTags;

+ (NSValueTransformer*) closedDateJSONTransformer;

@end
