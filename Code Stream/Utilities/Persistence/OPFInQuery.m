//
//  OPFInQuery.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-22.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFInQuery.h"

@implementation OPFInQuery

- (NSString*) baseSQL
{
    NSString* output = [NSString stringWithFormat:@"'%@'.'%@' IN (%@)", [self.rootQuery tableName], [self columnName], [self termsToString]];
    return output;
}

- (NSString*) termsToString
{
    return [self.terms componentsJoinedByString:@","];
}

+ (OPFInQuery*) initWithColumn:(NSString *)column terms:(NSArray *)terms rootQuery:(OPFQuery *)rootQuery
{
    OPFInQuery* query = [[OPFInQuery alloc] init];
    query.columnName = column;
    query.terms = terms;
    query.rootQuery = rootQuery;
    return query;
}

@end
