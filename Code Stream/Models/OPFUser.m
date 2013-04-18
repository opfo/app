//
//  User.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUser.h"
#import "DatabaseAccess.h"

@interface OPFUser (/*private */)
@property(assign, readwrite) NSInteger identifier;
@property(strong, readwrite) NSDate* creationDate;
@end

@implementation OPFUser

//
// Returns all user objects in the database
+ (NSArray*) all {
    return nil;
}


@end
