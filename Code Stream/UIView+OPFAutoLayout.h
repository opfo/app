//
//  UIView+OPFAutoLayout.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (OPFAutoLayout)

/// Add the given view to this view as a subview and autoresizes it to fill
/// this view.
- (void)opf_addFillingAutoresizedSubview:(UIView *)aView;


/// Remove all subviews from the view.
- (void)opf_removeAllSubviews;

@end
