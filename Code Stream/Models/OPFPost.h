//
//  OPFPost.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "MTLModel.h"
#import "OPFUser.h"
#import "OPFModel.h"

typedef enum : NSInteger {
    QUESTION = 1,
    ANSWER = 2
} OPFPostType;

@interface OPFPost : MTLModel <OPFModel>

@property (assign, readonly) NSInteger identifier;
@property (strong, readonly) NSDate* creationDate;
@property (assign) OPFPostType postType;
@property (assign) NSInteger score;
@property (assign) NSInteger viewCount;
@property (copy) NSString* title;
@property (copy) NSString* body;
@property (weak) OPFUser* owner;
@property (weak) OPFUser* lastEditor;
@property (copy) NSString* lastEditorDisplayName;
@property (strong) NSDate* lastEditDate;
@property (strong) NSDate* lastActivityDate;
@property (strong) NSDate* communityOwnedDate;
@property (assign) NSInteger commentCount;
@property (assign) NSInteger favoriteCount;

- (NSArray *) comments;

@end
