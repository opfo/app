//
//  UIWebView+OPFHtmlView.h
//  Code Stream
//
//  Created by Martin Goth on 2013-05-15.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (OPFHtmlView)
- (void)opf_loadHTMLString:(NSString*) string;
@end
