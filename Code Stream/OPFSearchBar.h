//
//  OPFSearchBar.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 04-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSLineView;


// Adds a border at the top of the search bar.
@interface OPFSearchBar : UISearchBar

// The height of the border view defauls to 2 points.
@property (strong, nonatomic, readonly) SSLineView *topBorderView;

@end
