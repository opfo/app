//
//  OPFStyleController.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 27-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Handles application wide styling of UIAppearance or UIAppearanceContainer
 compliant classes.
 */
@interface OPFStyleController : NSObject

/**
 Apply the shared application styles.
 
 Only needs to be called once, preferably from the
 -application:didFinishLaunchingWithOptions: method.
 */
+ (void)applyStyle;

@end
