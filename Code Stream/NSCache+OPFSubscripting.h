//
//  NSCache+OPFSubscripting.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 17-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCache (OPFSubscripting)

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id)key;

@end
