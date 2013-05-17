//
//  OPFAppState.m
//  Code Stream
//
//  Created by Tobias Deekens on 30.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFAppState.h"
#import "OPFUser.h"
#import "NSString+OPFMD5Hash.h"

@interface OPFAppState()

+ (void)peristLoginForEmailHash:(NSString *)eMail;

@end

@implementation OPFAppState

+ (instancetype)sharedAppState
{
	static OPFAppState *_sharedAppState = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedAppState = self.new;
	});
	return _sharedAppState;
}

- (BOOL)isLoggedIn
{
	return (self.user != nil);
}

@synthesize user = _user;
- (void)setUser:(OPFUser *)user
{
	if (_user != user) {
		[self willChangeValueForKey:CDStringFromSelector(isLoggedIn)];
		_user = user;
		[self didChangeValueForKey:CDStringFromSelector(isLoggedIn)];
	}
}

- (OPFUser *)user
{
	//self.userModel = [[[OPFUser query] whereColumn:@"id" is:@"797"] getOne];
    //To lazy to cache the response here
	return _user;
}

- (BOOL)loginWithEmailHash:(NSString *)emailHash password:(NSString *)password persistLogin:(BOOL)persistLogin
{
	NSParameterAssert(emailHash.length > 0);
	
	OPFUser *loggedInUser = [OPFUser.query whereColumn:@"email_hash" is:emailHash].getOne;
	if (loggedInUser) {
		self.user = loggedInUser;
		
		if (persistLogin) {
			[self.class peristLoginForEmailHash:emailHash];
		}
		
		return YES;
	}
	return NO;
}

+ (BOOL)tryAutoLogin
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *emailHash = [userDefaults objectForKey:@"eMailHash"];
    
    if (emailHash.length > 0) {
        return [self.sharedAppState loginWithEmailHash:emailHash password:nil persistLogin:NO];
    } else {
        return NO;
    }
}

- (void)logout
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"eMailHash"];
    self.user = nil;
}

#pragma mark - Private methods
+ (void)peristLoginForEmailHash :(NSString *)eMailHash
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:eMailHash forKey:@"eMailHash"];
    [userDefaults synchronize];
}


#pragma mark - Deprecated methods
+ (OPFUser *)userModel
{
    return [(OPFAppState *)self.sharedAppState user];
}

+ (void)setUserModel:(OPFUser *)userModel
{
    [(OPFAppState *)self.sharedAppState setUser:userModel];
}

+ (BOOL)loginWithEMailHash:(NSString *)eMailHash andPassword:(NSString *)password persistLogin:(BOOL)persistFlag
{
	return [(OPFAppState *)self.sharedAppState loginWithEmailHash:eMailHash password:password persistLogin:persistFlag];
}

+ (void)logout
{
    [(OPFAppState *)self.sharedAppState logout];
}

+ (BOOL)isLoggedIn
{
	return [(OPFAppState *)self.sharedAppState isLoggedIn];
}


@end
