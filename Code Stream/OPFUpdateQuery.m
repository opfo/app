//
//  OPFUpdateQuery.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-10.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUpdateQuery.h"
#import "OPFDatabaseAccess.h"
#import "OPFQuestion.h"
#import <stdlib.h>
#import "OPFDateFormatter.h"
#import "OPFDBInsertionIdentifier.h"

@implementation OPFUpdateQuery


+(BOOL) insertInto: (NSString *) tableName forColumns: (NSArray *) attributes values:(NSArray *) values auxiliaryDB: (BOOL) auxDB{
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@(",tableName];
    
    for(NSUInteger i=0;i<[attributes count];i++){
        if(i!=[attributes count]-1)
            query = [query stringByAppendingFormat:@"%@,", [attributes objectAtIndex:i]];
        else
           query = [query stringByAppendingFormat:@"%@", [attributes objectAtIndex:i]];
    }
    query = [query stringByAppendingString:@") VALUES("];
    for(NSUInteger i=0;i<[attributes count];i++){
        if(i!=[attributes count]-1)
            query = [query stringByAppendingString:@"?,"];
        else
            query = [query stringByAppendingString:@"?);"];
    }
    
    BOOL succeeded = auxDB ? [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray:values auxiliaryUpdate:YES] :
    [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray:values auxiliaryUpdate:auxDB];
    
    return succeeded;
}

+(BOOL) updateTable: (NSString *) tableName setValues: (NSArray *) setString where: (NSString *) whereString values: (NSArray *) values auxiliaryDB: (BOOL) auxDB{
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@;",tableName,values,whereString];
    
    BOOL succeeded = [[OPFDatabaseAccess getDBAccess] executeUpdate:query withArgumentsInArray:values auxiliaryUpdate:auxDB];
    
    return succeeded;
}

@end