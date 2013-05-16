//
//  UIImage+OPFScalingAndResizing.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 14-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIImage+OPFScalingAndResizing.h"

@implementation UIImage (OPFScalingAndResizing)

#pragma mark - Creating New Images
+ (instancetype)opf_resizableImageNamed:(NSString *)name withCapInsets:(UIEdgeInsets)capInsets
{
	return [self opf_resizableImageNamed:name withCapInsets:capInsets resizingMode:UIImageResizingModeTile];
}

+ (instancetype)opf_resizableImageNamed:(NSString *)name withCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
{
	UIImage *image = [UIImage imageNamed:name];
	image = [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
	return image;
}

@end
