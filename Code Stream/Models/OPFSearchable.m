//
//  OPFSearchable.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSearchable.h"

@interface OPFSearchable (/* Private */)

+ (NSString*) matchClauseFromSearchString: (NSString*) searchString;

@end

@implementation OPFSearchable

+ (NSString*) indexTableName
{
    [NSException raise:@"Invalid call on abstract method" format:@""];
    return nil;
}

+ (OPFQuery*) searchFor:(NSString *)searchTerms
{
    NSString* queryFormat = @"SELECT object_id FROM auxDB.%@ WHERE index_string MATCH %@";
    NSString* joinQueryForm = @"SELECT '%@'.* FROM '%@' INNER JOIN auxDB.%@ ON '%@'.'id' = '%@'.'object_id' WHERE '@%'.'index_string' MATCH '%@'";
    NSString* output = [NSString stringWithFormat:queryFormat, [self indexTableName], [self matchClauseFromSearchString:searchTerms]];
    FMResultSet* result = [[OPFDatabaseAccess getDBAccess] executeSQL:output];
    NSMutableArray* objectIds = [[NSMutableArray alloc] init];
    while ([result next]) {
        [objectIds addObject: @([result intForColumn:@"object_id"])];
    }
    return [[self query] whereColumn:@"id" in:objectIds];
}
+ (NSString*) matchClauseFromSearchString: (NSString*) searchString
{
    /**
     This method could later be used to tweak the query string.
     For now we will return the input.
     For example usage see below:
     
     NSArray* tokens = [searchString componentsSeparatedByString:@" "];
     NSMutableArray* wildCardTokens = [[NSMutableArray alloc] initWithCapacity: [tokens count]];
     for(id token in tokens) {
     [wildCardTokens addObject:[NSString stringWithFormat:@"%@*", token]];
     }
     NSString* output = [wildCardTokens componentsJoinedByString:@" AND "];
     return output;
     */
    return [NSString stringWithFormat:@"'%@'", searchString];
}

@end
