//
//  OPFAnswer.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPost.h"
#import "OPFQuestion.h"

@interface OPFAnswer : OPFPost

@property (strong) NSNumber* parentId;
@property (strong) OPFQuestion* parent;

@end
