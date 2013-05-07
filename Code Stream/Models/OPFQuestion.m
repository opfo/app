//
//  OPFQuestion.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestion.h"
#import "OPFAnswer.h"
#import "OPFTag.h"


@implementation OPFQuestion

+ (OPFRootQuery*) query
{
    return [[super query] whereColumn:@"post_type_id" is:@(KOPF_POST_TYPE_QUESTION)];
}

+ (NSValueTransformer*) closedDateJSONTransformer
{
    return [self standardDateTransformer];
}

@synthesize answers = _answers;

- (NSArray*) answers
{
    if(_answers == nil) {
        OPFQuery* query = [[OPFAnswer query] whereColumn:@"parent_id" is:self.identifier];
        _answers = [query getMany];
    }
    return _answers;
}

@synthesize acceptedAnswer = _acceptedAnswer;

- (OPFAnswer*) acceptedAnswer
{
    if (_acceptedAnswer == nil)
    {
        OPFQuery* query = [[OPFAnswer query] whereColumn:@"id" is:self.acceptedAnswerId];
        _acceptedAnswer = [query getOne];
    }
    return _acceptedAnswer;
}

- (void) setAcceptedAnswer:(OPFAnswer *)acceptedAnswer
{
    if(acceptedAnswer != _acceptedAnswer) {
        _acceptedAnswer = acceptedAnswer;
        _acceptedAnswerId = acceptedAnswer.identifier;
    }
}

+(NSValueTransformer*) tagsJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [OPFTag rawTagsToArray: str];
    } reverseBlock:^(NSArray *array) {
        return [OPFTag arrayToRawTags: array];
    }];
}

+(OPFSearchQuery*) searchFor:(NSString *)searchTerms
{
    return [[super searchFor:searchTerms] whereColumn:@"post_type_id" is: @(KOPF_POST_TYPE_QUESTION)];
}

+ (OPFQuery*) withTags:(NSArray *)tags
{
    return [[super withTags:tags] whereColumn:@"post_type_id" is: @(KOPF_POST_TYPE_QUESTION)];
}

+ (OPFQuery*) searchFor:(NSString *)searchTerms inTags:(NSArray *)tags
{
    return [[super searchFor:searchTerms inTags:tags] whereColumn:@"post_type_id" is: @(KOPF_POST_TYPE_QUESTION)];
}

+ (NSArray *)hotQuestions
{
	return [self.hotQuestionsQuery getMany];
}

+ (OPFQuery *)hotQuestionsQuery
{
	return [[[self.query whereColumn:@"score" isGreaterThan:@(0) orEqual:YES] orderBy:@"last_activity_date" order:kOPFSortOrderAscending] limit:@(50)];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { id = %@; title = \"%@\"; }>", self.class, self, self.identifier, self.title];
}

@end
