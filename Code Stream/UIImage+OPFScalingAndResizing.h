//
//  UIImage+OPFScalingAndResizing.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 14-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OPFScalingAndResizing)

#pragma mark - Creating New Images
// Like combining +imageNamed: and -resizableImageWithCapInset:resizingMode: in
// one method call, awesome.
+ (instancetype)opf_resizableImageNamed:(NSString *)name withCapInsets:(UIEdgeInsets)capInsets;
+ (instancetype)opf_resizableImageNamed:(NSString *)name withCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;

@end
