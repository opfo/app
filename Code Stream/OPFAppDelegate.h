//
//  OPFAppDelegate.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 11-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFTabbedHomeViewController;

@interface OPFAppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)sharedAppDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) OPFTabbedHomeViewController *tabbedHomeViewController;

@end
