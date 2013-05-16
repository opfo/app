//
//  UIImage+OPFScoreImages.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 14-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OPFScoreImages)

+ (UIImage *)opf_postStatusImageForScore:(NSInteger)score hasAcceptedAnswer:(BOOL)hasAcceptedAnswer;

@end
