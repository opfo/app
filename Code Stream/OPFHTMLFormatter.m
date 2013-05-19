//
//  OPFHTMLFormatter.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-19.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFHTMLFormatter.h"

@implementation OPFHTMLFormatter

+(NSString *) removeHTMLTags:(NSString *)input
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<([^<>]+)>" options:0 error:&error];
    NSString* output = [regex stringByReplacingMatchesInString:input options:0 range:NSMakeRange(0, [input length]) withTemplate:@""];
    return output;
}

@end

