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


/**
 * The following methods have been deprecated.
 *
 * It is better to have a singleton getter than class methods as it makes it
 * easier to for instance observe values.
 */
@interface OPFAppState (OPFDeprecated)

// Use `OPFAppState.sharedAppState.user` instead.
+ (OPFUser *)userModel OPF_APP_STATE_DEPRECATED;
// Use `OPFAppState.sharedAppState.user = ...` instead.
+ (void) setUserModel:(OPFUser *)userModel OPF_APP_STATE_DEPRECATED;
// Use `[OPFAppState.sharedAppState loginWithEmailHash:password:persistentLogin:]` instead.
+ (BOOL)loginWithEMailHash:(NSString *)eMailHash andPassword:(NSString *)password persistLogin:(BOOL)persistFlag OPF_APP_STATE_DEPRECATED;
// Use `[OPFAppState.sharedAppState logout]` instead.
+ (void)logout OPF_APP_STATE_DEPRECATED;
// Use `OPFAppState.sharedAppState.isLoggedIn` instead.
+ (BOOL)isLoggedIn OPF_APP_STATE_DEPRECATED;

@end
