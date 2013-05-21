//
//  NSDateFormatter+OPFDateFormatters.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 20-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "NSDateFormatter+OPFDateFormatters.h"

@implementation NSDateFormatter (OPFDateFormatters)

+ (instancetype)opf_dateFormatterWithFormat:(NSString *)format
{
	NSDateFormatter *dateFormatter = self.new;
	dateFormatter.dateFormat = format;
	return dateFormatter;
}

+ (NSString *)opf_currentDateAsStringWithDateFormat:(NSString *)format
{
	NSDateFormatter *dateFormatter = [self opf_dateFormatterWithFormat:format];
    return [dateFormatter stringFromDate:NSDate.date];
}

@end
