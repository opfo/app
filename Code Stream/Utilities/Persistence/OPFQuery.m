//
//  OPFQuery.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-21.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuery.h"

@implementation OPFQuery

- (instancetype) getOne {
    return nil;
}
- (NSArray*) getMany {
    return nil;
}
- (instancetype) column: (NSString*) column like: (NSString*) term {
    return nil;
}
- (instancetype) column: (NSString*) column is: (NSString*) term{
    return nil;
}
- (instancetype) column: (NSString*) column in: (NSArray*) terms{
    return nil;
}
- (instancetype) and: (OPFQuery*) otherQuery{
    return nil;
}
- (instancetype) or: (OPFQuery*) otherQuery{
    return nil;
}
- (instancetype) limit: (NSInteger) n{
    return nil;
}

@end
