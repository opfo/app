//
//  OPFQuery.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPFDatabaseAccess.h"

typedef NSArray* (^OnGetMany)(FMResultSet*);
typedef id (^OnGetOne)(NSDictionary*);

typedef enum : NSInteger { kOPFSortOrderAscending, kOPFSortOrderDescending } OPFSortOrder;

// Used to query objects in a SQLite database using FMDB
// Principle:
//  1. Fetch a root query from the wanted model
//  2. Start chaining away
//  3. Calling further queries on a query will result in a AND-query
//  4. Call getOne or getMany to return a FMResultSet*
//
//      Example:
//      [[[[OPFComment query] column: @"post_id" is: @"2"] column: @"text" like: @"%%CSS%%"] column: @"user_id" in: @[@"1", @"2", @"3"]]
//          => "SELECT 'comments'.* FROM 'comments'
//              WHERE ('comments'.'post_id' = 2 AND ('comments'.'text' LIKE '%CSS%' AND 'comments'.'user_id' IN (1,2,3)))"
@interface OPFQuery : NSObject

@property (copy) NSString* tableName;
@property (copy) NSString* columnName;
@property (copy) NSString* dbName;
@property (assign) BOOL paged;

@property (copy, nonatomic) OnGetMany onGetMany;
@property (copy, nonatomic) OnGetOne onGetOne;

// A query that the current query should be AND:ed with
@property (strong) OPFQuery* andQuery;

// A query that the current query should be OR:ed with
// TODO: not implemented yet
@property (strong) OPFQuery* orQuery;

// All queries, except for the root query itself, must have a rootQuery
@property (strong) OPFQuery* rootQuery;
@property (strong) NSNumber* limit;
@property (strong) NSNumber* pageSize;
@property (strong) NSNumber* offset;
@property (copy) NSString* orderByColumn;
@property (assign) OPFSortOrder order;

// Fetches one database row based on the query
// Equivalent to setting LIMIT = 1
- (FMResultSet*) getResultSetOne;

// Fetches all database rows that match the query
- (FMResultSet*) getResultSetMany;

// Fetches one row from the database and applies the onGetOne-callback
- (id) getOne;
// Fetches the rows from the database and applies the onGetMany-callback
- (NSArray*) getMany;

// Create a LIKE query and set is as an AND query for this query
- (instancetype) whereColumn: (NSString*) column like: (id) term;

// Create an IS (equals) query and set is as an AND query for this query
- (instancetype) whereColumn: (NSString*) column is: (id) term;

// Create an IS greater (or equals) query and set is as an AND query for this query
- (instancetype) whereColumn: (NSString*) column isGreaterThan: (id) term orEqual:(BOOL)equal;

// Create an IS less (or equals) query and set is as an AND query for this query
- (instancetype) whereColumn: (NSString*) column isLessThan: (id) term orEqual:(BOOL)equal;

// Create an IN query and set is as an AND query for this query
- (instancetype) whereColumn: (NSString*) column in: (NSArray*) terms;

// Set a query as the conjunction query of this query
- (instancetype) andQuery: (OPFQuery*) otherQuery;

// Set a query as the disjunction query of this query
// TODO: Not implemented yet
- (instancetype) orQuery: (OPFQuery*) otherQuery;
- (instancetype) limit: (NSNumber*) n;
- (instancetype) page: (NSNumber*) page;
- (instancetype) page: (NSNumber*) page per: (NSNumber*) pageSize;
- (instancetype) orderBy: (NSString*) column order: (OPFSortOrder) sortOrder;

// Returns this query as it would appear in a WHERE-block
//      Example:
//      [[[OPFComment query] column: @"foo", is: @"bar"] baseSQL]
//          => "'comments'.'foo' = 'bar'"
- (NSString*) baseSQL;

// Returns the query as it would appear in a WHERE-block with its conjunctions or disjunctions
//  Note: disjunctions not implemented yet
//      Example:
//      [[[[OPFComment query] column: @"score" is: @"1"] column: @"post_id" is: @"1"] toSQLString]
//          => ('comments'.'score' = 1 AND 'comments'.'post_id' = 1)
- (NSString*) toSQLString;

// Constructs the conjunction using own baseSQL and the conjunction query's toSQLString
- (NSString*) sqlForAnd;

// Adds a string the existing SQL string
- (NSString*) sqlConcat: (NSString*) sqlString;

+ (instancetype) queryWithTableName:(NSString *)tableName dbName: (NSString *) dbName oneCallback: (OnGetOne) oneCallback manyCallback: (OnGetMany) manyCallback pageSize: (NSNumber*)pageSize;

@end
