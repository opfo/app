//
//  User.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-16.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "OPFModel.h"
#import "OPFRecordProtocol.h"
#import "OPFSearchable.h"

@interface OPFUser : OPFSearchable

@property (strong, readonly) NSNumber* identifier;
@property (strong) NSNumber* reputation;
@property (strong, readonly) NSDate* creationDate;
@property (copy) NSString* displayName;
@property (copy) NSString* emailHash;
@property (strong) NSDate* lastAccessDate;
@property (copy) NSURL* websiteUrl;
@property (copy) NSString* location;
@property (strong) NSNumber* age;
@property (copy) NSString* aboutMe;
@property (strong) NSNumber* view;
@property (strong) NSNumber* upVotes;
@property (strong) NSNumber* downVotes;

- (NSArray *) questionsPage: (NSInteger) page;
- (NSArray *) answersPage: (NSInteger) page;
- (NSArray *) commentsPage: (NSInteger) page;

@end
