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

+ (OPFUser *)userModel;
+ (void) setUserModel:(OPFUser *)userModel;
+ (BOOL)loginWithUsername :(NSString *)userName andPassword :(NSString *)password;
+ (BOOL)isLoggedIn;

@end
