//
//  OPFSignupView.m
//  Code Stream
//
//  Created by Tobias Deekens on 02.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSignupView.h"
#import "OPFUser.h"

@implementation OPFSignupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (BOOL)validateSignup
{
    return NO;
}

- (OPFUser *)deserializeSignup
{
    return [OPFUser new];
}

@end
