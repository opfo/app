//
//  OPFComment.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFComment.h"

@implementation OPFComment

+ (NSArray *) all
{
    return nil;
}

+ (NSArray *) where:(NSDictionary *)attributes
{
    return nil;
}

+ (id) find:(NSInteger)identifier
{
    FMResultSet* result = [self findModel: @"" withIdentifier: identifier];
    if([result next]) {
//        NSDictionary* attributes = [result resultDictionary];
    }
    return nil;
}

@end
