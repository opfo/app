//
//  OPFIsQuery.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuery.h"

@interface OPFIsQuery : OPFQuery

// The search term
@property (copy) NSString* term;

+ (instancetype) initWithColumn: (NSString*) column term: (NSString*) term rootQuery: (OPFQuery*) otherQuery;
@end
