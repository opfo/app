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

+ (BOOL)loginWithEMail :(NSString *)eMail andPassword :(NSString *)password;
{
    __strong OPFUser *loggedInUserModel = [[[OPFUser query] whereColumn:@"email_hash" is:eMail.opf_md5hash] getOne];
    
    if (loggedInUserModel) {
        userModel = loggedInUserModel;
        
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

@end
