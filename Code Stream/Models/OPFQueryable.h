//
//  OPFQueryable.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPFRootQuery.h"

@protocol OPFQueryable <NSObject>

+ (OPFRootQuery*) query;

@end
