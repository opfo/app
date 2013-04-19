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
    NSString* sql = [NSString stringWithFormat:@"SELECT '%@'.* FROM '%@' WHERE '%@'.'id' = %d  LIMIT 1", modelName, modelName, modelName, identifier];
    NSLog(sql);
    return [[self getDBAccess] executeSQL: sql];
}

+ (NSDateFormatter*) dateFormatter
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    // Need to change locale later?
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd";
    return formatter;
}

@end
