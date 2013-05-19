//
//  OPFDateFormatter.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-19.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFDateFormatter.h"

@implementation OPFDateFormatter

// Return current date
+(NSString *) currentDateAsStringWithDateFormat: (NSString *) format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
