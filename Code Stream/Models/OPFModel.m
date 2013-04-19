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

+ (FMResultSet *) allForModel:(NSString *)modelName{
    NSString* sql = [NSString stringWithFormat:@"SELECT '%@' FROM '%@'", modelName, modelName];
    return [[self getDBAccess] executeSQL:sql];
}

+ (FMResultSet *) allForModel:(NSString *)modelName page:(NSInteger)page {
    return [self allForModel:modelName page:page per: [self defaultPageSize]];
}

+ (FMResultSet *) allForModel:(NSString *)modelName page:(NSInteger)page per:(NSInteger)per {
    NSInteger offset = per * page;
    NSString* sql = [NSString stringWithFormat:@"SELECT '%@' FROM '%@' LIMIT %d OFFSET %d", modelName, modelName, per, offset];
    return [[self getDBAccess] executeSQL:sql];
}

+ (FMResultSet *) findModel:(NSString *)modelName withIdentifier:(NSInteger)identifier
{
    NSString* sql = [NSString stringWithFormat:@"SELECT '%@'.* FROM '%@' WHERE '%@'.'id' = %d  LIMIT 1", modelName, modelName, modelName, identifier];
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

+ (NSInteger) defaultPageSize {
    return 10;
}

@end
