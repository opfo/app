//
//  OPFModel.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFModel.h"
#import "OPFRootQuery.h"

@implementation OPFModel

+ (OPFDatabaseAccess*) getDBAccess
{
    return [OPFDatabaseAccess getDBAccess];
}

# pragma mark - Generic find all methods

+ (FMResultSet *) allForModel:(NSString *)modelName{
    NSString* sql = [NSString stringWithFormat:@"SELECT '%@' FROM '%@'", modelName, modelName];
    return [[self getDBAccess] executeSQL:sql];
}

+ (FMResultSet *) allForModel:(NSString *)modelName page:(NSInteger)page {
    return [self allForModel:modelName page:page per: [self defaultPageSize]];
}

+ (FMResultSet *) allForModel:(NSString *)modelName page:(NSInteger)page per:(NSInteger)per {
    NSInteger offset = per * page;
    NSString* sql = [NSString stringWithFormat:@"SELECT '%@'.* FROM '%@' LIMIT %d OFFSET %d", modelName, modelName, per, offset];
    return [[self getDBAccess] executeSQL:sql];
}

# pragma mark - Generic find one model method

+ (FMResultSet *) findModel:(NSString *)modelName withIdentifier:(NSInteger)identifier
{
    NSString* sql = [NSString stringWithFormat:@"SELECT '%@'.* FROM '%@' WHERE '%@'.'id' = %d  LIMIT 1", modelName, modelName, modelName, identifier];
    return [[self getDBAccess] executeSQL: sql];
}

# pragma mark - Generic where methods

+ (FMResultSet*) findModel:(NSString *)modelName where: (NSDictionary*) attributes
{
    return nil;
}

# pragma mark - Find All methods used by the actual models

+ (NSArray *) all
{
    FMResultSet* result = [self allForModel: [self modelTableName]];
    return [self parseMultipleResult:result];
}

+ (NSArray *) all:(NSInteger)page
{
    FMResultSet* result = [self allForModel:[self modelTableName] page:page];
    return [self parseMultipleResult:result];
}

// Find page [page] of all models with [pageSize]
+ (NSArray*) all:(NSInteger) page per:(NSInteger)pageSize
{
    FMResultSet* result = [self allForModel:[self modelTableName] page:page per:pageSize];
    return [self parseMultipleResult: result];
}

# pragma mark - Find one model by identifier

// Find a single model
+ (instancetype) find:(NSInteger)identifier
{
    FMResultSet* result = [self findModel: [self modelTableName] withIdentifier: identifier];
    NSError* error;
    if([result next]) {
        NSDictionary* attributes = [result resultDictionary];
        id model =[MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:attributes error: &error];
        [result close];
        return model;
    } else {
        NSLog(@"Model not found");
        [result close];
        return nil;
    }
}

# pragma mark - Data parsing methods

+ (NSDateFormatter*) dateFormatter
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    // Need to change locale later?
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"sv_SE"];
    formatter.dateFormat = @"yyyy-MM-dd";
    return formatter;
}

//  Returns model objects for each row in a FMResultSet.
+ (NSArray *) parseMultipleResult: (FMResultSet*) result
{
    NSMutableArray* models = [[NSMutableArray alloc] init];
    id model;
    while([result next]) {
        model = [self parseDictionary:[result resultDictionary]];
        [models addObject: model];
    }
    [result close];
    return models;
}

//  Takes a dictionary and returns a populated model class
+ (instancetype) parseDictionary: (NSDictionary*) attributes {
    NSError* error;
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:attributes error: &error];
}

//  Self-explanatory.
+ (NSInteger) defaultPageSize {
    return 10;
}

+ (NSString*) modelDBName
{
    return @"so.sqlite";
}

// This method needs to be overridden by subclasses
+ (NSString*) modelTableName
{
    [NSException raise:@"Invalid call on abstract method" format:@""];
    return nil;
}

// This method needs to be overridden by subclasses
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [NSException raise:@"Invalid call on abstract method" format:@""];
    return nil;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [self standardDateTransformer];
}

+ (NSValueTransformer *)standardDateTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSString*) dbName
{
    return @"baseDB";
}

# pragma mark - Query

+ (OPFRootQuery*) query
{
    OnGetOne singleModelCallback = ^(NSDictionary* attributes){
        return [self parseDictionary:attributes];
    };
    OnGetMany multipleModelCallback = ^(FMResultSet* result) {
        return [self parseMultipleResult:result];
    };
    return [OPFRootQuery queryWithTableName: [self modelTableName] dbName: [self dbName] oneCallback: singleModelCallback manyCallback:multipleModelCallback];
}

@end
