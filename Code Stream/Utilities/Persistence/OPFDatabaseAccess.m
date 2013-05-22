//
//  DatabaseAccess.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFDatabaseAccess.h"

static BOOL OPFDBOverwriteDBs = (OPF_DATABASE_ACCESS_DEBUG) == 1;
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
    BOOL successBase;
    BOOL successAux;
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString* defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:OPFDefaultDBFilename];
	NSString* auxDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:OPFAuxDBFilename];
    NSError *error;
	
	if (OPFDBOverwriteDBs || [self isFileAtPath:defaultDBPath newerThanFileAtPath:OPFWritableBaseDBPath usingFileManager:fileManager]) {
		[fileManager removeItemAtPath:OPFWritableBaseDBPath error:&error];
	}
	if (OPFDBOverwriteDBs || [self isFileAtPath:auxDBPath newerThanFileAtPath:OPFWritableAuxDBPath usingFileManager:fileManager]) {
		[fileManager removeItemAtPath:OPFWritableAuxDBPath error:&error];
	}
	
    successBase = [fileManager fileExistsAtPath: OPFWritableBaseDBPath];
    successAux = [fileManager fileExistsAtPath:OPFWritableAuxDBPath];
    if (!successBase) {
		DLogNotice(@"Will update base database.");
        successBase = [fileManager copyItemAtPath:defaultDBPath toPath: OPFWritableBaseDBPath error: &error];
		ACLog(successBase == NO, @"Failed to copy base database to documents directory");
		DCLogNotice(OPF_DATABASE_ACCESS_DEBUG && successBase, @"Did update base database.");
    }
    if (!successAux) {
		DLogNotice(@"Will update auxiliary database");
        successAux = [fileManager copyItemAtPath:auxDBPath toPath: OPFWritableAuxDBPath error: &error];
		ACLog(successAux == NO, @"Failed to copy auxiliary database to documents directory");
		DCLogNotice(OPF_DATABASE_ACCESS_DEBUG && successBase, @"Did update auxiliary database.");
    }
}

+ (BOOL)isFileAtPath:(NSString *)path newerThanFileAtPath:(NSString *)otherPath usingFileManager:(NSFileManager *)fileManager
{
	NSDictionary *pathAttributes = [fileManager attributesOfItemAtPath:path error:nil];
	NSDictionary *otherPathAttributes = [fileManager attributesOfItemAtPath:otherPath error:nil];
	
	return (pathAttributes.fileCreationDate != nil && otherPathAttributes.fileCreationDate != nil && ([pathAttributes.fileCreationDate isEqualToDate:otherPathAttributes.fileCreationDate] == NO));
}

//
//  Inits with the preinstalled database.
- (id) init {
    self = [super init];
    if (self == nil) return nil;
    _auxAttached = NO;
    [OPFDatabaseAccess setDBPaths];
    [OPFDatabaseAccess copyDatabaseIfNeeded];
    _combinedQueue = [OPFDatabaseQueue databaseQueueWithPath:OPFWritableBaseDBPath];
    _auxCombinedQueue = [OPFDatabaseQueue databaseQueueWithPath:OPFWritableAuxDBPath];
    [self attachAuxDB];
    return self;
}

//
// Executes an SQL string and returns the result.
// Returns nil if result is empty.
// Returns nil if db is unavailable.
- (FMResultSet *) executeSQL:(NSString *)sql
{
    [self attachAuxDB];
    __block FMResultSet* result;
    [_combinedQueue inDatabase: ^(FMDatabase* db) {
        DCLog(OPF_DATABASE_ACCESS_DEBUG, @"Executing query %@", sql);
        result = [db executeQuery:sql];
    }];
    return result;
}

// Execute an SQL-update query
// Returns YES if update succeeded, NO otherwise
- (BOOL) executeUpdate:(NSString *) sql withArgumentsInArray: (NSArray*) array auxiliaryUpdate: (BOOL) auxUpdate
{
    [self attachAuxDB];
    __block BOOL succeeded;
    
    if(auxUpdate){
        [_auxCombinedQueue inDatabase:^(FMDatabase* db){
            succeeded = [db executeUpdate:sql withArgumentsInArray:array];
        }];
    }
    else{
        [_combinedQueue inDatabase:^(FMDatabase* db){
            succeeded = [db executeUpdate:sql withArgumentsInArray:array];
        }];
    }
    
    return succeeded;
}

-(void) attachAuxDB
{
    if (!self.auxAttached) {
        [_combinedQueue inDatabase:^(FMDatabase* db){
            BOOL result = [db executeUpdate:@"ATTACH DATABASE ? AS 'auxDB'" withArgumentsInArray:@[OPFWritableAuxDBPath]];
            if (result) {
                DCLog(OPF_DATABASE_ACCESS_DEBUG, @"Successfully attached aux db");
                self.auxAttached = YES;
            } else {
                DCLog(OPF_DATABASE_ACCESS_DEBUG, @"Failed to attach aux db");
                self.auxAttached = NO;
            }
        }];
    }
}

-(void) close
{
    self.auxAttached = NO;
    [_combinedQueue close];
    [_auxCombinedQueue close];
}

- (int) lastInsertRowId
{
    __block NSNumber* id;
    [_combinedQueue inDatabase:^(FMDatabase* db){
        id = @([db lastInsertRowId]);
    }];
    return [id integerValue];
}

@end

@implementation OPFDatabaseQueue

- (dispatch_queue_t)queue
{
	return _queue;
}

@end

