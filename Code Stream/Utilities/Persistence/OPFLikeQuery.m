//
//  OPFLikeQuery.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-22.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFLikeQuery.h"

@implementation OPFLikeQuery

- (NSString*) baseSQL
{
    NSString* formatString;
    if (self.exact == YES) {
        formatString = @"'%@'.'%@' LIKE '%@'";
    } else {
        formatString = @"'%@'.'%@' LIKE '%%%@%%'";
    }
    NSString* output = [NSString stringWithFormat: formatString, [self.rootQuery tableName], [self columnName], [self term]];
    return output;
}

+ (OPFLikeQuery*) initWithColumn:(NSString *)column term:(id)term rootQuery:(OPFQuery *)rootQuery
{
    OPFLikeQuery* query = [[OPFLikeQuery alloc] init];
    query.columnName = column;
    query.term = term;
    query.rootQuery = rootQuery;
    return query;
}

+ (instancetype) initWithColumn:(NSString *)column term:(id)term rootQuery:(OPFQuery *)otherQuery exact:(BOOL)exact
{
    OPFLikeQuery* query = [self initWithColumn:column term:term rootQuery:otherQuery];
    query.exact = exact;
    return query;
}

@end
