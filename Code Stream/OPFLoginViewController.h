//
//  OPFLoginViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 02.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFLoginViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDataSource>

@property(strong, nonatomic) UITextField *eMailField;
@property(strong, nonatomic) UITextField *passwordField;

- (NSString *)tabImageName;
- (NSString *)tabTitle;

- (IBAction)userRequestsLogin:(id)sender;

@end
