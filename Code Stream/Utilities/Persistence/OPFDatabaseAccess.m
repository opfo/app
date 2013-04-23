//
//  DatabaseAccess.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFDatabaseAccess.h"

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
    NSString* databasePath = [[NSBundle mainBundle] pathForResource:@"so" ofType:@"sqlite"];
    _baseDB = [FMDatabase databaseWithPath: databasePath];
    _baseDBQueue = [FMDatabaseQueue databaseQueueWithPath: databasePath];
    return self;
}

//
// Executes an SQL string and returns the result.
// Returns nil if result is empty.
// Returns nil if db is unavailable.
- (FMResultSet *) executeSQL:(NSString *)sql
{
    if([_baseDB open]) {
        NSLog(@"Opened database");
        NSLog([NSString stringWithFormat:@"Executing SQL: %@", sql]);
        __block FMResultSet* result;
        [_baseDBQueue inDatabase: ^(FMDatabase* db) {
            result = [db executeQuery:sql];
        }];
        return result;
    } else {
        NSLog(@"Failed to open database");
        return nil;
    }
}

-(void) close
{
    [_baseDB close];
}

@end
