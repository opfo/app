//
//  OPFPost.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "MTLModel.h"

@interface OPFQuestion : OPFPost

@property (strong) NSArray* tags;
@property (strong) OPFAnswer* acceptedAnswer;
@property (strong) NSDate* closedDate;
@property (assign) NSInteger answerCount;

@end
