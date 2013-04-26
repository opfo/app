//
//  DatabaseAccess.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFDatabaseAccess.h"

static NSString* OPFDefaultDB = @"baseDB";

@implementation OPFDatabaseAccess

//
//  Returns the singleton database instance
+ (instancetype) getDBAccess;
{
	static id _sharedDatabase = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedDatabase = [[self alloc] init];
	});
	return _sharedDatabase;
}

//
//  Inits with the preinstalled database.
- (id) init {
    self = [super init];
    if (self == nil) return nil;
    NSString* baseDBPath = [[NSBundle mainBundle] pathForResource:@"so" ofType:@"sqlite"];
    NSString* auxDBPath = [[NSBundle mainBundle] pathForResource:@"auxiliary" ofType:@"sqlite"];
    _baseDB = [FMDatabase databaseWithPath: baseDBPath];
    _baseDBQueue = [FMDatabaseQueue databaseQueueWithPath: baseDBPath];
    _auxDB = [FMDatabase databaseWithPath:auxDBPath];
    _auxDBQueue = [FMDatabaseQueue databaseQueueWithPath:auxDBPath];
    _dataBaseIndex = @{@"baseDB": _baseDBQueue, @"auxDB":  _auxDBQueue};
    [_auxDBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"CREATE VIRTUAL TABLE IF NOT EXISTS docs USING fts3(name, contents);"];
        if([db hadError]) {
            NSLog(@"===================PHAT ERROR ======\n ==> %@ \n <=======", [db lastErrorMessage]);
        }
    }];
    return self;
}

//
// Executes an SQL string and returns the result.
// Returns nil if result is empty.
// Returns nil if db is unavailable.
- (FMResultSet *) executeSQL:(NSString *)sql withDatabase: (NSString*) databaseName
{
    FMDatabaseQueue* db = [self.dataBaseIndex valueForKey:databaseName];
//    if([_baseDB open]) {
//        NSLog(@"Opened database");
//        NSLog([NSString stringWithFormat:@"Executing SQL: %@", sql]);
//        __block FMResultSet* result;
//        [_baseDBQueue inDatabase: ^(FMDatabase* db) {
//            result = [db executeQuery:sql];
//        }];
//        return result;
//    } else {
//        NSLog(@"Failed to open database");
//        return nil;
//    }
    __block FMResultSet* result;
    NSLog(@"Executing SQL on db %@: %@", databaseName, sql);
    [db inDatabase: ^(FMDatabase* db) {
        result = [db executeQuery:sql];
    }];
    return result;
}

- (FMResultSet *) executeSQL:(NSString *)sql
{
    NSLog(@"Using default db");
    return [self executeSQL: sql withDatabase:OPFDefaultDB];
}

-(void) close
{
    [_baseDB close];
}

@end
