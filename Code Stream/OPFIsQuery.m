//
//  OPFIsQuery.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFIsQuery.h"

@implementation OPFIsQuery : OPFQuery

+ (instancetype) initWithColumn: (NSString*) column term: (NSString*) term rootQuery: (OPFQuery*) otherQuery
{
    return [self initWithColumn:column term:term type:kOPFIsQueryEqual rootQuery:otherQuery];
}

+ (instancetype)initWithColumn:(NSString *)column term:(id)term type:(OPFIsQueryType)type rootQuery:(OPFQuery *)otherQuery
{
	OPFIsQuery *query = [[self alloc] init];
	query.columnName = column;
	query.term = term;
	query.type = type;
	query.rootQuery = otherQuery;
	return query;
}

- (NSString *)operation
{
	NSString *operation = nil;
	switch (self.type) {
		case kOPFIsQueryEqual: operation = @"="; break;
		
		case kOPFIsQueryGreater: operation = @">"; break;
		case kOPFIsQueryGreaterOrEqual: operation = @">="; break;
		
		case kOPFIsQueryLess: operation = @"<"; break;
		case kOPFIsQueryLessOrEqual: operation = @"<="; break;
		
		default:
			operation = @"=";
			ZAssert(NO, @"Unknown operation type %d", self.type);
			break;
	}
	return operation;
}

- (NSString *)baseSQL
{
	return [NSString stringWithFormat:@"'%@'.'%@' %@ '%@'", [self.rootQuery tableName], [self columnName], [self operation], [self term]];
}

@end
