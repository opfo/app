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

@interface OPFComment : MTLModel <OPFModel>

@property (assign, readonly) NSInteger identifier;
@property (strong) OPFPost* post;
@property (assign) NSInteger score;
@property (copy) NSString* text;
@property (strong) NSDate* creationDate;
@property (strong) OPFUser* author;

@end
