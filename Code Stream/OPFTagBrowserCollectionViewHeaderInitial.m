//
//  OPFTagBrowserCollectionViewHeader.m
//  Code Stream
//
//  Created by Tobias Deekens on 09.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTagBrowserCollectionViewHeaderInitial.h"
#import "UIView+OPFViewLoading.h"
#import "OPFTag.h"

@interface OPFTagBrowserCollectionViewHeaderInitial()

- (void)opfSetupView;
- (void)setModelValuesInView;

@end

@implementation OPFTagBrowserCollectionViewHeaderInitial

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

- (void)setTagModel:(OPFTag *)tagModel
{
    _tagModel = tagModel;
}

#pragma mark - Private methods

- (void)opfSetupView
{

}

- (void)setModelValuesInView
{
}


@end
