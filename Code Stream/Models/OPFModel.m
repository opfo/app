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

# pragma mark - Find All methods used by the actual models

+ (NSArray *) all
{
    return [[self query] getMany];
}

+ (NSArray *) all:(NSInteger)page
{
    return [[[self query] page:@(page)] getMany];
}

// Find page [page] of all models with [pageSize]
+ (NSArray*) all:(NSInteger) page per:(NSInteger)pageSize
{
    return [[[self query]  page: @(page) per: @(pageSize)] getMany];
}

# pragma mark - Find one model by identifier

// Find a single model
+ (instancetype) find:(NSInteger)identifier
{
    id result = [[[self query] whereColumn:@"id" is:@(identifier)] getOne];
    return result;
}

#pragma mark - Refreshing Objects
- (instancetype)refreshedObject
{
	return [self.class find:self.identifier.integerValue];
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

+ (NSValueTransformer *)creationDateJSONTransformer {
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
    return @"main";
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
    return [OPFRootQuery queryWithTableName: [self modelTableName]
                                     dbName: [self dbName]
                                oneCallback: singleModelCallback
                               manyCallback: multipleModelCallback
                                   pageSize: @([self defaultPageSize])];
}

- (BOOL) isEqual:(id)other
{
    if(self == other) {
        return YES;
    }
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToModel: other];
}

- (BOOL) isEqualToModel:(OPFModel*) other
{
    if (self == other)
        return YES;
    if (![self.identifier isEqual: other.identifier])
        return NO;
    return YES;
}

- (NSUInteger) hash
{
    NSUInteger hash = 0;
    hash += [[self.class modelTableName] hash];
    hash += [[self identifier] integerValue];
    return hash;
}

@end
