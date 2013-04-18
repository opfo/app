//
//  OPFCommentViewHeader.m
//  Code Stream
//
//  Created by Tobias Deekens on 17.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFCommentViewHeader.h"
#import "UIView+OPFViewLoading.h

@implementation OPFCommentViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [self opf_loadViewFromNIB];
    
    return self;
}

@end
