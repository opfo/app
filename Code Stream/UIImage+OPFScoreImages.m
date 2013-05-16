//
//  UIImage+OPFScoreImages.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 14-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "UIImage+OPFScoreImages.h"

@implementation UIImage (OPFScoreImages)

+ (UIImage *)opf_postStatusImageForScore:(NSInteger)score hasAcceptedAnswer:(BOOL)hasAcceptedAnswer
{
	UIImage *answersIndicatorImage = nil;
	if (hasAcceptedAnswer) {
		answersIndicatorImage = [UIImage imageNamed:@"post-accepted@2x"];
	} else if (score < 0) {
		answersIndicatorImage = [UIImage imageNamed:@"post-negative@2x"];
	} else {
		answersIndicatorImage = [UIImage imageNamed:@"post-normal@2x"];
	}
	return answersIndicatorImage;
}




@end
