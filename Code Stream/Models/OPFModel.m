//
//  OPFModel.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFModel.h"

@implementation OPFModel

+ (OPFDatabaseAccess*) getDBAccess
{
    return [OPFDatabaseAccess getDBAccess];
}

@end
