//
//  UIScrollView+OPFScrollDirection.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 07-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _OPFUIScrollViewDirection : NSInteger {
    kOPFUIScrollViewDirectionNone		= 0,
    kOPFUIScrollViewDirectionRight		= 1 << 0,
    kOPFUIScrollViewDirectionLeft		= 1 << 1,
    kOPFUIScrollViewDirectionUp			= 1 << 2,
	kOPFUIScrollViewDirectionDown		= 1 << 3,
} OPFUIScrollViewDirection;


@interface UIScrollView (OPFScrollDirection)

- (OPFUIScrollViewDirection)opf_scrollViewScrollingDirection;
+ (OPFUIScrollViewDirection)opf_scrollViewScrollingDirection:(UIScrollView *)scrollView;

@end
