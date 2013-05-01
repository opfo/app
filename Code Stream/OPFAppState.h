//
//  OPFAppState.h
//  Code Stream
//
//  Created by Tobias Deekens on 30.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPFUser;

@interface OPFAppState : NSObject

@property (strong, nonatomic) OPFUser *userModel;

+ (OPFUser *)userModel;

@end
