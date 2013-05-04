//
//  OPFRootQuery.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-22.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFRootQuery.h"

@implementation OPFRootQuery : OPFQuery

- (NSString*) toSQLString
{
    NSMutableString* output;
    if ([self andQuery] == nil) {
        output = [NSMutableString stringWithString:[self baseSQL]];
    } else {
        output = [NSMutableString stringWithString:[self sqlConcat: [[self andQuery] toSQLString]]];
    }
    if ([self orderByColumn] != nil) {
        [output appendString:@" "];
        NSString* order = self.order == kOPFSortOrderAscending ? @"ASC" : @"DESC";
        [output appendString: [NSString stringWithFormat:@"ORDER BY '%@'.'%@' %@", self.tableName, self.orderByColumn, order]];
    }
    if([self limit] != nil) {
        [output appendString:@" "];
        [output appendString:[NSString stringWithFormat: @"LIMIT %@", self.limit]];
    }
    if([self paged] == YES) {
        [output appendString:@" "];
        [output appendString:[NSString stringWithFormat: @"LIMIT %@ ", self.pageSize]];
        [output appendString: [NSString stringWithFormat: @"OFFSET %@", self.offset]];
    }
    return output;
}

- (NSString*) baseSQL
{
    NSString* output = [NSString stringWithFormat:@"SELECT '%@'.* FROM '%@'.'%@'", [self tableName], [self dbName], [self tableName]];
    return output;
}

- (NSString*) sqlConcat:(NSString *) other
{
    NSMutableString* output = [NSMutableString stringWithString: [self baseSQL]];
    [output appendString:@" "];
    [output appendString: [NSString stringWithFormat:@"WHERE %@", [[self andQuery] toSQLString]]];
    return output;
}

@end
