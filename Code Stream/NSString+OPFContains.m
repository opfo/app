//
//  NSString+OPFContains.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 02-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "NSString+OPFContains.h"

@implementation NSString (OPFContains)

- (BOOL)opf_containsString:(NSString *)string
{
	return ([self rangeOfString:string].location != NSNotFound);
}

@end
