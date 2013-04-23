//
//  OPFAnswer.m
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFAnswer.h"

@implementation OPFAnswer

+ (OPFRootQuery*) query
{
    OnGetOne singleModelCallback = ^(NSDictionary* attributes){
        return [self parseDictionary:attributes];
    };
    OnGetMany multipleModelCallback = ^(FMResultSet* result) {
        return [self parseMultipleResult:result];
    };
    OPFRootQuery* rootQuery = [OPFRootQuery queryWithTableName: [self modelTableName] oneCallback: singleModelCallback manyCallback:multipleModelCallback];
    return [rootQuery whereColumn:@"post_type_id" is: @(KOPF_POST_TYPE_ANSWER)];
}

@synthesize parent = _parent;

- (OPFQuestion*) parent
{
    if(_parent == nil) {
        OPFQuery* query = [[OPFQuestion query] whereColumn:@"id" is:self.parentId];
        _parent = [query getOne];
    }
    return _parent;
}

- (void) setParent:(OPFQuestion *)parent
{
    if(parent != _parent) {
        _parent = parent;
        _parentId = parent.identifier;
    }
}


@end
