//
//  DatabaseAccess.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface OPFDatabaseAccess : NSObject

+ (instancetype) getDBAccess;

- (FMResultSet *) executeSQL: (NSString *) sql;
- (FMResultSet *) executeSQL: (NSString *) sql withDatabase: (NSString*) databaseName;
- (void) close;

@property(strong, readonly) FMDatabase* baseDB;
@property(strong, readonly) FMDatabase* auxDB;
@property(strong, readonly) FMDatabaseQueue* baseDBQueue;
@property(strong, readonly) FMDatabaseQueue* auxDBQueue;
@property(strong, readonly) NSDictionary* dataBaseIndex;

@end
