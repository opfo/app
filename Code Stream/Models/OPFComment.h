//
//  OPFComment.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "MTLModel.h"
#import "OPFModel.h"
#import "OPFPost.h"
#import "OPFModel.h"

@interface OPFComment : OPFModel

@property (assign, readonly) NSInteger identifier;
@property (strong) OPFPost* post;
@property (strong) NSNumber* score;
@property (copy) NSString* text;
@property (strong) NSDate* creationDate;
@property (assign) NSInteger author_id;
@property (strong) OPFUser* author;
@property (strong, readonly) NSDictionary* keyTransformations;

@end
