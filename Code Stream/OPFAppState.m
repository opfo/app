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

+ (void)peristLoginForEmailHash :(NSString *)eMail;

@end

@implementation OPFAppState

static OPFUser *userModel;

+ (OPFUser *)userModel
{
    //self.userModel = [[[OPFUser query] whereColumn:@"id" is:@"797"] getOne];
    
    //To lazy to cache the response here
    return userModel;
}

+ (void)setUserModel:(OPFUser *)userModel
{
    self.userModel = userModel;
}

+ (BOOL)loginWithEMailHash :(NSString *)eMailHash andPassword :(NSString *)password persistLogin:(BOOL)persistFlag
{
    __strong OPFUser *loggedInUserModel = [[[OPFUser query] whereColumn:@"email_hash" is:eMailHash] getOne];
    
    if (loggedInUserModel) {
        userModel = loggedInUserModel;
        
        if (persistFlag == YES) {
            [self peristLoginForEmailHash:eMailHash];
        }
        
        return YES;
    }
    
    return NO;
}

+ (void)logout
{
    userModel = nil;
}

+ (BOOL)isLoggedIn
{
    return userModel != nil ? true : false;
}

+ (BOOL)tryAutoLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *eMailHash = [userDefaults objectForKey:@"eMailHash"];
    
    if (eMailHash != nil) {
        return [self loginWithEMailHash:eMailHash andPassword:nil persistLogin:NO];
    } else {
        return NO;
    }
}

#pragma mark - Private methods

+ (void)peristLoginForEmailHash :(NSString *)eMailHash
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:eMailHash forKey:@"eMailHash"];
    
    [userDefaults synchronize];
}

@end
