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
    OPFIsQuery* query = [[OPFIsQuery alloc] init];
    query.columnName = column;
    query.term = term;
    query.rootQuery = otherQuery;
    return query;
}

- (NSString*) baseSQL
{
    return [NSString stringWithFormat:@"'%@'.'%@' = %@", [self.rootQuery tableName], [self columnName], [self term]];
}

@end
