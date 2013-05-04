//
//  OPFSearchQuery.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSearchQuery.h"

@implementation OPFSearchQuery

+(instancetype) searchQueryWithTableName:(NSString *)tableName
                                  dbName:(NSString *)dbName
                             oneCallback:(OnGetOne)oneCallback
                            manyCallback:(OnGetMany)manyCallback
                                pageSize:(NSNumber *)pageSize
                          indexTableName:(NSString *)indexTableName
                              searchTerm:(NSString *)searchTerm
{
    id query = [self queryWithTableName:tableName dbName:dbName oneCallback:oneCallback manyCallback:manyCallback pageSize:pageSize];
    [query setIndexTableName:indexTableName];
    [query setSearchTerms:searchTerm];
    return query;
}

- (NSString*) baseSQL
{
    NSString* joinQueryFormat = @"SELECT '%@'.* FROM '%@' INNER JOIN auxDB.%@ ON '%@'.'id' = '%@'.'object_id' WHERE %@ MATCH '%@'";
    NSString* output = [NSString stringWithFormat:joinQueryFormat, [self tableName], [self tableName], [self indexTableName], [self tableName], [self indexTableName], [self indexTableName], [self searchTerms]];
    return output;
}

- (NSString*) sqlConcat:(NSString *) other
{
    NSMutableString* output = [NSMutableString stringWithString: [self baseSQL]];
    [output appendString:@" "];
    [output appendString: [NSString stringWithFormat:@" AND %@", [[self andQuery] toSQLString]]];
    return output;
}

@end
