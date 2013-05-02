//
//  OPFSearchable.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFModel.h"
#import "OPFSearchQuery.h"

//  Abstract class
//  Enables full text SQLite queries on subclasses
//  Prerequisites:
//      - fts-table with a minimum of two columns:
//          - object_id [foreign key for connected object]
//          - index_string [the string to be indexed]
@interface OPFSearchable : OPFModel

//  Returns a query which performs a search based on the current models index table name,
//  Can be chained with standard OPFQuery methods.
+ (OPFSearchQuery*) searchFor: (NSString*) searchTerms;

//  Has to be overridden by subclasses
+ (NSString*) indexTableName;

//  Transforms a string of tokens into a string of column namespaced tokens,
//  suitable for SQLite FTS MATCH-clauses
//  Example:
//      "apa bepa cepa"
//      => "index_string:apa index_string:bepa index_string:cepa"
+ (NSString*) matchClauseFromSearchString: (NSString*) searchString;

@end
