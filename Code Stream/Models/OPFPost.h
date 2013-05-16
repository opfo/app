//
//  OPFPost.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "MTLModel.h"
#import "OPFUser.h"
#import "OPFSearchable.h"
#import "OPFRecordProtocol.h"

typedef enum : NSInteger {
    KOPF_POST_TYPE_QUESTION = 1,
    KOPF_POST_TYPE_ANSWER = 2
} OPFPostType;

@interface OPFPost : OPFSearchable <OPFRecordProtocol>

@property (strong, readonly) NSDate* creationDate;
@property (assign) OPFPostType postType;
@property (strong) NSNumber* score;
@property (strong) NSNumber* viewCount;
@property (copy) NSString* title;
@property (copy) NSString* body;
@property (strong) NSNumber* ownerId;
@property (strong) OPFUser* owner;
@property (strong) OPFUser* lastEditor;
@property (strong) NSNumber* lastEditorId;
@property (copy) NSString* lastEditorDisplayName;
@property (strong) NSDate* lastEditDate;
@property (strong) NSDate* lastActivityDate;
@property (strong) NSDate* communityOwnedDate;
@property (strong) NSNumber* commentCount;
@property (strong) NSNumber* favoriteCount;
@property (strong, readonly) NSArray* comments;

//  Allows for SQLite full text index search queries to be performed simultaneously on tags and free text
//  Example
//  Searches for posts with contains apa and bepa at least once and contains mysql and css tags:
//  [OPFQuery searchFor: @"apa bepa" inTags: @[@"mysql", @"css"]]
+ (OPFQuery*) searchFor: (NSString*) searchTerms inTags: (NSArray*) tags;
+ (OPFQuery*) withTags: (NSArray*) tags;
@end
