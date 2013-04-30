//
//  OPFAppState.m
//  Code Stream
//
//  Created by Tobias Deekens on 30.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFAppState.h"
#import "OPFUser.h"

@implementation OPFAppState

+ (OPFUser *)userModel
{
    OPFUser *userModel = [[[OPFUser query] whereColumn:@"id" is:@"13"] getOne];
    
    //To lazy to cache the response here
    return userModel;
}

@end
