//
//  OPFQuery.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPFQuery : NSObject

@property (copy) NSString* tableName;
@property (copy) NSString* columnName;
@property (strong) OPFQuery* andQuery;
@property (strong) OPFQuery* orQuery;
@property (strong) OPFQuery* rootQuery;

- (instancetype) getOne;
- (NSArray*) getMany;
- (instancetype) column: (NSString*) column like: (NSString*) term;
- (instancetype) column: (NSString*) column is: (NSString*) term;
- (instancetype) column: (NSString*) column in: (NSArray*) terms;
- (instancetype) and: (OPFQuery*) otherQuery;
- (instancetype) or: (OPFQuery*) otherQuery;
- (instancetype) limit: (NSInteger) n;
- (NSString*) toSQLString;
- (NSString*) sqlConcat: (NSString*) sqlString;
+ (instancetype) queryWithTableName: (NSString*) tableName;

@end
