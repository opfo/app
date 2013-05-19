//
//  OPFUpdateQuery.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-10.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPFUpdateQuery : NSObject

+(BOOL) insertInto: (NSString *) tableName forColumns: (NSArray *) attributes values:(NSArray *) values auxiliaryDB: (BOOL) auxDB;

+(BOOL) updateTable: (NSString *) tableName setValues: (NSArray *) setString where: (NSString *) whereString values: (NSArray *) values auxiliaryDB: (BOOL) auxDB;

@end
