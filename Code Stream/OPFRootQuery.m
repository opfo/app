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
    NSLog(@"=============>>>> SQL STRING METHOD CALL");
    if ([self andQuery] == nil) {
        return [self baseSQLString];
    } else {
        return [self sqlConcat: [[self andQuery] toSQLString]];
    }
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
