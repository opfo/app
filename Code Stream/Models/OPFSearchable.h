//
//  OPFSearchable.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFModel.h"

@interface OPFSearchable : OPFModel

+ (OPFQuery*) searchFor: (NSString*) searchTerms;
// Has to be overridden by subclasses
+ (NSString*) indexTableName;

@end
