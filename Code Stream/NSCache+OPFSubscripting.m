//
//  NSCache+OPFSubscripting.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 17-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "NSCache+OPFSubscripting.h"

@implementation NSCache (OPFSubscripting)

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id)key
{
	[self setObject:object forKey:key];
}

@end
