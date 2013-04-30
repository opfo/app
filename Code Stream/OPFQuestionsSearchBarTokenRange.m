//
//  OPFQuestionsSearchBarTokenRange.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 30-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsSearchBarTokenRange.h"

@implementation OPFQuestionsSearchBarTokenRange

+ (instancetype)tokenRangeWithRange:(NSRange)range
{
	return [[self alloc] initWithRange:range];
}

- (instancetype)initWithRange:(NSRange)range
{
	self = [super init];
	if (self) {
		_range = range;
	}
	return self;
}

- (NSUInteger)location
{
	return self.range.location;
}

- (NSUInteger)length
{
	return self.range.length;
}

@end
