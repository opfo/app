//
//  OPFPostBodyTableViewCell.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFPostBodyTableViewCell : UITableViewCell <UIWebViewDelegate>

@property (copy, nonatomic) NSString *htmlString;
@property (weak, nonatomic) IBOutlet UIWebView *bodyTextView;
@end
