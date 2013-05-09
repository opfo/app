//
//  OPFOPFTagBrowserCollectionViewHeaderTag.m
//  Code Stream
//
//  Created by Tobias Deekens on 09.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTagBrowserCollectionViewHeaderTag.h"

@interface OPFTagBrowserCollectionViewHeaderTag()

- (void)opfSetupView;

@end

@implementation OPFTagBrowserCollectionViewHeaderTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self opfSetupView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

#pragma mark - Private methods

- (void)opfSetupView
{
    
}

@end