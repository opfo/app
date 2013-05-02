//
//  DatabaseAccess.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFDatabaseAccess.h"

static NSString* OPFDefaultDB = @"baseDB";
static NSString* OPFDefaultDBFilename = @"so.sqlite";
static NSString* OPFAuxDBFilename = @"auxiliary.sqlite";
static NSString* OPFWritableBaseDBPath;
static NSString* OPFWritableAuxDBPath;

@interface OPFDatabaseAccess(/*private*/)
+ (void) copyDatabaseIfNeeded;
@end

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

+ (void) setDBPaths
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    OPFWritableBaseDBPath = [documentsDirectory stringByAppendingPathComponent: OPFDefaultDBFilename];
    OPFWritableAuxDBPath = [documentsDirectory stringByAppendingPathComponent: OPFAuxDBFilename];
}

+ (void) copyDatabaseIfNeeded
{
    // First, test for existence.
    BOOL successBase;
    BOOL successAux;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    successBase = [fileManager fileExistsAtPath: OPFWritableBaseDBPath];
    successAux = [fileManager fileExistsAtPath:OPFWritableAuxDBPath];
    if (!successBase) {
        NSString* defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:OPFDefaultDBFilename];
        successBase = [fileManager copyItemAtPath:defaultDBPath toPath: OPFWritableBaseDBPath error: &error];
    }
    if (!successAux) {
        NSString* auxDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:OPFAuxDBFilename];
        successAux = [fileManager copyItemAtPath:auxDBPath toPath: OPFWritableAuxDBPath error: &error];
    }
    if(!successBase) {
        NSLog(@"Failed to copy base db to documents directory");
    }
    if(!successAux) {
        NSLog(@"Failed to copy aux db to documents directory");
    }
}

//
//  Inits with the preinstalled database.
- (id) init {
    self = [super init];
    if (self == nil) return nil;
    [OPFDatabaseAccess setDBPaths];
    [OPFDatabaseAccess copyDatabaseIfNeeded];
    _baseDBQueue = [FMDatabaseQueue databaseQueueWithPath: OPFWritableBaseDBPath];
    _auxDBQueue = [FMDatabaseQueue databaseQueueWithPath:OPFWritableAuxDBPath];
    _combinedQueue = [FMDatabaseQueue databaseQueueWithPath:OPFWritableBaseDBPath];
    [_combinedQueue inDatabase:^(FMDatabase* db){
        BOOL result = [db executeUpdate:@"ATTACH DATABASE ? AS 'auxDB'" withArgumentsInArray:@[OPFWritableAuxDBPath]];
        if (result) {
            NSLog(@"Successfully attached aux db");
        } else {
            NSLog(@"Failed to attach aux db");
        }
    }];
    _dataBaseIndex = @{@"baseDB": _baseDBQueue, @"auxDB":  _auxDBQueue};
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
