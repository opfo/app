//
//  OPFModel.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFModel.h"

@implementation OPFModel

+ (OPFDatabaseAccess*) getDBAccess
{
    return [OPFDatabaseAccess getDBAccess];
}

+ (FMResultSet *) findModel:(NSString *)modelName withIdentifier:(NSInteger)identifier
{
    NSString* sql = [NSString stringWithFormat:@"SELECT 'user'.* FROM '%@' LIMIT 1", modelName];
    return [[self getDBAccess] executeSQL: sql];
}

@end
