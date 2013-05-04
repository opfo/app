//
//  OPFSearchable.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSearchable.h"

@interface OPFSearchable (/* Private */)

+ (NSString*) matchClauseFromSearchString: (NSString*) searchString;

@end

@implementation OPFSearchable

+ (NSString*) indexTableName
{
    [NSException raise:@"Invalid call on abstract method" format:@""];
    return nil;
}

+ (OPFSearchQuery*) searchFor: (NSString*) searchTerms
{
    OnGetOne singleModelCallback = ^(NSDictionary* attributes){
        return [self parseDictionary:attributes];
    };
    OnGetMany multipleModelCallback = ^(FMResultSet* result) {
        return [self parseMultipleResult:result];
    };
    OPFSearchQuery* query = [OPFSearchQuery searchQueryWithTableName:[self modelTableName]
                                                        dbName:[self dbName]
                                                   oneCallback:singleModelCallback
                                                  manyCallback:multipleModelCallback
                                                      pageSize:@([self defaultPageSize])
                                                indexTableName:[self indexTableName]
                                                    searchTerm:[self matchClauseFromSearchString:searchTerms]];
    return query;
}

+ (NSString*) matchClauseFromSearchString: (NSString*) searchString
{
    NSArray* tokens = [searchString componentsSeparatedByString:@" "];
    NSMutableArray* tokensWithColumnName = [[NSMutableArray alloc] init];
    for(id token in tokens) {
        if ([token length] != 0) {
            [tokensWithColumnName addObject: [NSString stringWithFormat:@"index_string:%@", token]];
        }
    }
    return [tokensWithColumnName componentsJoinedByString:@" "];
}

@end
