//
//  OPFModelTestHelper.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-19.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFModelSpecHelper.h"

@implementation OPFModelSpecHelper

+(NSInteger) countResult: (FMResultSet*) result {
    NSInteger i = 0;
    while([result next]) {
        i++;
    }
    return i;
}

@end
