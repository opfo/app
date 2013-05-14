//
//  OPFRequireLoginViewController.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-14.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFSignupViewController.h"
#import "OPFLoginViewController.h"

@interface OPFRequireLoginViewController : UIViewController
@property OPFSignupViewController *signupViewController;
@property OPFLoginViewController *loginViewController;
@end
