//
//  OPFTag.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-24.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTag.h"
#import "OPFQuestion.h"

NSInteger kOPFPopularTagsLimit = 20;

@implementation OPFTag

+ (NSString*) dbName
{
    return @"auxDB";
}

//
// Translates incoming dictionary keys into the names of the target properties
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"name": @"name",
             @"counter":@"counter"
             };
}

@synthesize questions = _questions;

- (NSArray*) questions
{
    if (_questions == nil) {
        OPFQuery* query = [[OPFQuestion query] whereColumn:@"tags" like: [NSString stringWithFormat:@"%%%@%%", self.name]];
        _questions = [query getMany];
    }
    return _questions;
}

+ (NSString*) modelTableName
{
    return @"tags";
}

+ (NSString*) arrayToRawTags:(NSArray *)array
{
    NSMutableString *resultString = [NSMutableString stringWithString:@"<"];
    [resultString appendString:[array componentsJoinedByString:@"><"]];
    [resultString appendString:@">"];
    return [NSString stringWithString:resultString];
}

+ (NSArray*) rawTagsToArray:(NSString *)rawTags
{
    NSMutableArray* matches = [[NSMutableArray alloc]init];
    NSError* error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"<([^<>]+)>" options:NSRegularExpressionCaseInsensitive error: &error];
    [regex enumerateMatchesInString:rawTags options: 0 range: NSMakeRange(0, [rawTags length]) usingBlock: ^(NSTextCheckingResult* match, NSMatchingFlags flags, BOOL *stop){
        NSString* stringMatch = [rawTags substringWithRange:[match rangeAtIndex:1]];
        [matches addObject:stringMatch];
    }];
    return matches;
}

+ (instancetype) byName:(NSString *)name
{
    return [[[self query] whereColumn:@"name" is: name] getOne];
}

+ (NSArray*) relatedTagsForTagWithName:(NSString *)name
{
    __block NSMutableArray* tags = [[NSMutableArray alloc] init];
    [[[OPFDatabaseAccess getDBAccess] combinedQueue] inDatabase:^(FMDatabase* db){
        FMResultSet* result = [db executeQuery:@"SELECT 'tags'.*, 'tag_frequencies'.'counter' FROM 'auxDB'.'tags' INNER JOIN 'auxDB'.'tag_frequencies' ON 'tag_frequencies'.'second_tag' = 'tags'.'name' WHERE 'tag_frequencies'.'first_tag' = ? ORDER BY 'tag_frequencies'.'counter' DESC LIMIT 10" withArgumentsInArray:@[name]];
        while([result next]) {
            [tags addObject:[self parseDictionary:result.resultDictionary]];
        }
        [result close];
    }];
    return tags;
}

- (NSArray*) relatedTags
{
    return [OPFTag relatedTagsForTagWithName:self.name];
}

+ (NSArray *)mostCommonTags
{
	return [[[self.query orderBy:@"counter" order:kOPFSortOrderDescending] limit:@(20)] getMany];
}

+ (OPFQuery*) mostCommonTagsQuery
{
    return [self.query orderBy: @"counter" order: kOPFSortOrderDescending];
}

//  We need to override hash so that we don't fetch all related question when generating a hash code (see hash in MTLModel)
- (NSUInteger)hash {
	NSUInteger value = 0;
    value ^= [self.identifier hash];
    value ^= [self.name hash];
	return value;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { id = %@; name = \"%@\"; }>", self.class, self, self.identifier, self.name];
}


@end
