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
    NSString* output = [NSString stringWithFormat:@"'%@'.'%@' LIKE '%@'", [self.rootQuery tableName], [self columnName], [self term]];
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

@end
