//
//  OPFQuestionsSearchBarTokenRange.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 30-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPFQuestionsSearchBarTokenRange : NSObject

+ (instancetype)tokenRangeWithRange:(NSRange)range;
- (instancetype)initWithRange:(NSRange)range;

@property (assign, readonly) NSRange range;
@property (assign, readonly) NSUInteger location;
@property (assign, readonly) NSUInteger length;

@end
