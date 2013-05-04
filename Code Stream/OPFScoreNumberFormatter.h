//
//  OPFScoreNumberFormatter.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 19-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>


// A formatter which handles post score and user reputation score.
//
// This class is **not** thread-safe.
@interface OPFScoreNumberFormatter : NSObject

// Whether the formatter should output the score on long form.
//
// Short form: _54.3k_
// Long form: _54,339_
//
// Defaults to `NO`.
@property (assign) BOOL shouldUseLongForm;

- (NSUInteger)scoreFromString:(NSString *)string;
- (NSString *)stringFromScore:(NSInteger)score;
- (NSString *)stringFromScoreNumber:(NSNumber *)scoreNumber;

@end
