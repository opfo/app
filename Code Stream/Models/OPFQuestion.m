//
//  OPFQuestion.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestion.h"
#import "OPFAnswer.h"

@interface OPFQuestion ()
@property (readwrite) NSArray* tags;
@end

@implementation OPFQuestion

+ (OPFRootQuery*) query
{
    OnGetOne singleModelCallback = ^(NSDictionary* attributes){
        return [self parseDictionary:attributes];
    };
    OnGetMany multipleModelCallback = ^(FMResultSet* result) {
        return [self parseMultipleResult:result];
    };
    OPFRootQuery* rootQuery = [OPFRootQuery queryWithTableName: [self modelTableName] oneCallback: singleModelCallback manyCallback:multipleModelCallback];
    return [rootQuery whereColumn:@"post_type_id" is: @(KOPF_POST_TYPE_QUESTION)];
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

- (void)setRawTags:(NSString *)rawTags {
	NSRange range = { .location = 1, .length = rawTags.length-2 };
	NSString *substring = [rawTags substringWithRange:range];
	self.tags = [substring componentsSeparatedByString:@"><"];
}

- (NSString *)rawTags {
	NSMutableString *resultString = [NSMutableString stringWithString:@"<"];
	[resultString appendString:[self.tags componentsJoinedByString:@"><"]];
	[resultString appendString:@">"];
	return [NSString stringWithString:resultString];
}


@end
