//
//  User.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"

@interface OPFUser : MTLModel

@property (assign, readonly) NSInteger identifier;
@property (assign) NSInteger reputation;
@property (strong, readonly) NSDate* creationDate;
@property (copy) NSString* displayName;
@property (copy) NSString* emailHash;
@property (strong) NSDate* lastAccessDate;
@property (copy) NSString* websiteUrl;
@property (copy) NSString* location;
@property (assign) NSInteger age;
@property (copy) NSString* aboutMe;
@property (assign) NSInteger view;
@property (assign) NSInteger upVotes;
@property (assign) NSInteger downVotes;

+ (NSArray*) all;

@end
