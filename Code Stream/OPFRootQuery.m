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
        output = [NSMutableString stringWithString:[self baseSQLString]];
    } else {
        output = [NSMutableString stringWithString:[self sqlConcat: [[self andQuery] toSQLString]]];
    }
    if([self limit] != nil) {
        [output appendString:@" "];
        [output appendString:[NSString stringWithFormat: @"LIMIT %@", [self limit]]];
    }
    return output;
}

- (NSString*) baseSQLString
{
    NSString* output = [NSString stringWithFormat:@"SELECT '%@'.* FROM '%@'", [self tableName], [self tableName]];
    return output;
}

- (NSString*) sqlConcat:(NSString *) other
{
    NSMutableString* output = [NSMutableString stringWithString: [self baseSQLString]];
    [output appendString:@" "];
    [output appendString: [NSString stringWithFormat:@"WHERE %@", [[self andQuery] toSQLString]]];
    return output;
}

@end
