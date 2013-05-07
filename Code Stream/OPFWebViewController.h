//
//  OPFWebViewController.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-06.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFWebViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopLoading;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *openInSafari;

@property (weak, nonatomic) NSURL *page;

@end
