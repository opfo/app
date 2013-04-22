//
//  OPFInQuery.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-22.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuery.h"

// Represents an SQL IN-query
@interface OPFInQuery : OPFQuery

@property (strong) NSArray* terms;

// Returns a string representation of the array that is to be matched against
- (NSString*) termsToString;

+ (OPFInQuery*) initWithColumn: (NSString*) column terms: (NSArray*) terms rootQuery: (OPFQuery*) rootQuery;
@end
