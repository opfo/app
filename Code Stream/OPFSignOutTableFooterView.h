//
//  OPFSignoutTableFooterView.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 17-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>


extern const CGFloat kOPFSignOutTableFooterViewPaddingTop;
extern const CGFloat kOPFSignOutTableFooterViewPaddingBottom;
extern const CGFloat kOPFSignOutTableFooterViewPaddingLeft;
extern const CGFloat kOPFSignOutTableFooterViewPaddingRight;

@interface OPFSignOutTableFooterView : UIView

@property (assign, nonatomic) UIEdgeInsets padding;
@property (strong, nonatomic, readonly) UIButton *signOutButton;

@end
