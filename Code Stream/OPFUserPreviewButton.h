//
//  OPFUserPreviewButton.h
//  Code Stream
//
//  Created by Martin Goth on 2013-04-30.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OPFUser;

typedef enum : NSInteger {
	kOPFIconAlignLeft,
	kOPFIconAlignRight,
	kOPFIconAlignNone
} OPFIconAlign;

@interface OPFUserPreviewButton : UIButton

@property (strong) UILabel *displayNameLabel;
@property (strong) UILabel *scoreLabel;
@property (strong) UIImageView *userAvatar;
@property (nonatomic, copy) OPFUser *user;
@property (nonatomic, assign) OPFIconAlign iconAlign;


@end


