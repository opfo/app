//
//  User.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "User.h"
#import "DatabaseAccess.h"

@interface User (/*private */)
@property(assign, readwrite) NSInteger identifier;
@property(strong, readwrite) NSDate* creationDate;
@end

@implementation User

//
// Returns all user objects in the database
+ (NSArray*) all {
    return nil;
}


@end
