//
//  OPFComment.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFComment.h"

@implementation OPFComment

+ (NSString *) modelTableName
{
    return @"comments";
}

//
// Translates incoming dictionary keys into the names of the target properties
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"postId": @"post_id",
             @"score": @"score",
             @"text": @"text",
             @"creationDate": @"creation_date",
             @"authorId": @"user_id"
    };
}

@synthesize post = _post;

- (OPFPost*) post
{
    if (_post == nil) {
        OPFQuery* query = [[OPFPost query] whereColumn:@"id" is: self.postId];
        _post = [query getOne];
    }
    return _post;
}

- (void) setPost:(OPFPost *)post
{
    if (_post != post) {
        _post = post;
        _postId = post.identifier;
    }
}
@synthesize author = _author;

- (OPFUser*) author
{
    if (_author == nil) {
        OPFQuery* query = [[OPFUser query] whereColumn:@"id" is: self.authorId];
        _author = [query getOne];
    }
    return _author;
}

- (void) setAuthor:(OPFUser *)author
{
    if (_author != author) {
        _author = author;
        _authorId = author.identifier;
    }
}

@end
