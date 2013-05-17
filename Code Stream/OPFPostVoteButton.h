//
//  OPFPostVoteButton.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-15.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFPost.h"

@interface OPFPostVoteButton : UIButton
@property (strong, nonatomic) OPFPost *post;
@property (assign, nonatomic) BOOL buttonTypeUp;
@property (weak, nonatomic) OPFPostVoteButton *siblingVoteButton;
@end
