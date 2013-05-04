//
//  OPFIsQuery.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuery.h"

typedef enum : NSInteger {
	// The match must be equal to the term
	kOPFIsQueryEqual,
	// The match must be greater than the term.
	kOPFIsQueryGreater,
	// The match must be greater than or equal to the term.
	kOPFIsQueryGreaterOrEqual,
	// The match must be less than the term.
	kOPFIsQueryLess,
	// The match must be less than or equal to the term.
	kOPFIsQueryLessOrEqual
} OPFIsQueryType;


@interface OPFIsQuery : OPFQuery

// The search term
@property (copy) id term;
// Whether it is OK for the term to be equal.
@property (assign) OPFIsQueryType type;

+ (instancetype) initWithColumn: (NSString*) column term: (id) term rootQuery: (OPFQuery*) otherQuery;
+ (instancetype)initWithColumn:(NSString *)column term:(id)term type:(OPFIsQueryType)type rootQuery:(OPFQuery *)otherQuery;

@end
