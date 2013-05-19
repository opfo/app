//
//  OPFAppState.h
//  Code Stream
//
//  Created by Tobias Deekens on 30.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPFUser;

#define OPF_APP_STATE_DEPRECATED __attribute__((deprecated))

@interface OPFAppState : NSObject

+ (instancetype)sharedAppState;

@property (strong) OPFUser *user;
@property (assign, readonly, getter = isLoggedIn) BOOL loggedIn;

- (BOOL)loginWithEmailHash:(NSString *)emailHash password:(NSString *)password persistLogin:(BOOL)persistLogin;
+ (BOOL)tryAutoLogin;

- (void)logout;

@end

