//
//  User.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"

@interface User : MTLModel

@property (nonatomic, assign, readonly) NSInteger identifier;
@property (nonatomic, assign) NSInteger reputation;
@property (nonatomic, copy, readonly) NSDate* creationDate;
@property (nonatomic, copy) NSString* displayName;
@property (nonatomic, copy) NSString* emailHash;
@property (nonatomic, copy) NSDate* lastAccessDate;
@property (nonatomic, copy) NSString* websiteUrl;
@property (nonatomic, copy) NSString* location;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString* aboutMe;
@property (nonatomic, assign) NSInteger view;
@property (nonatomic, assign) NSInteger upVotes;
@property (nonatomic, assign) NSInteger downVotes;

@end
