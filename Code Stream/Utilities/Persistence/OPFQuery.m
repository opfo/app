//
//  OPFQuery.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuery.h"
#import "OPFIsQuery.h"
#import "OPFInQuery.h"


@implementation OPFQuery

@synthesize rootQuery = _rootQuery;

- (FMResultSet*) getOne {
    [[self rootQuery] setLimit: @(1)];
    FMResultSet* result = [[OPFDatabaseAccess getDBAccess] executeSQL: [self.rootQuery toSQLString]];
    return result;
}

- (FMResultSet*) getMany {
    FMResultSet* result = [[OPFDatabaseAccess getDBAccess] executeSQL: [self.rootQuery toSQLString]];
    return result;
}

- (instancetype) column: (NSString*) column like: (NSString*) term
{
    return nil;
}

- (instancetype) column: (NSString*) column is: (NSString*) term
{
    OPFIsQuery* query = [OPFIsQuery initWithColumn: column term: term rootQuery: self.rootQuery];
    self.andQuery = query;
    return query;
}

- (instancetype) column: (NSString*) column in: (NSArray*) terms{
    OPFInQuery* query = [OPFInQuery initWithColumn: column terms: terms rootQuery: self];
    self.andQuery = query;
    return query;
}

- (instancetype) and: (OPFQuery*) otherQuery
{
    self.andQuery = otherQuery;
    otherQuery.rootQuery = self.rootQuery;
    return nil;
}

- (void) setRootQuery:(OPFQuery *)rootQuery
{
    _rootQuery = rootQuery;
}

- (OPFQuery*) rootQuery
{
    if (_rootQuery != nil) {
        return _rootQuery;
    } else {
        return self;
    }
}

- (instancetype) or: (OPFQuery*) otherQuery
{
    return nil;
}

- (instancetype) limit: (NSNumber*) n
{
    [[self rootQuery] setLimit:n];
    return self;
}

- (NSString*) toSQLString
{
    if([self andQuery] != nil) {
        return [self sqlForAnd];
    } else {
        return [self baseSQL];
    }
}

- (NSString*) sqlForAnd
{
    NSMutableString* output = [NSMutableString stringWithString:@"("];
    [output appendString:[self baseSQL]];
    [output appendString:@" AND "];
    [output appendString:[[self andQuery] toSQLString]];
    [output appendString:@")"];
    return output;
}

# pragma mark - Factory methods

+ (instancetype) queryWithTableName: (NSString*) tableName
{
    id query = [[self alloc] init];
    [query setTableName: tableName];
    return query;
}

@end
