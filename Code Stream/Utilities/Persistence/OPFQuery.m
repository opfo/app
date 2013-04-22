//
//  OPFQuery.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuery.h"
#import "OPFIsQuery.h"

@implementation OPFQuery

@synthesize rootQuery = _rootQuery;

- (instancetype) getOne {
    return nil;
}

- (NSArray*) getMany {
    return nil;
}

- (instancetype) column: (NSString*) column like: (NSString*) term
{
    return nil;
}

- (instancetype) column: (NSString*) column is: (NSString*) term
{
    OPFIsQuery* query = [OPFIsQuery initWithColumn: column term: term rootQuery: self];
    self.andQuery = query;
    return query;
}

- (instancetype) column: (NSString*) column in: (NSArray*) terms{
    return nil;
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

- (instancetype) limit: (NSInteger) n
{
    return nil;
}

- (NSString*) toSQLString
{
    return nil;
}

# pragma mark - Factory methods

+ (instancetype) queryWithTableName: (NSString*) tableName
{
    id query = [[self alloc] init];
    [query setTableName: tableName];
    return query;
}

@end
