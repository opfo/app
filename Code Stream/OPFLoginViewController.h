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
@property(weak, nonatomic) IBOutlet UILabel *loginMessageLabel;
@property (weak, nonatomic) IBOutlet UISwitch *rememberUser;


- (NSString *)tabImageName;
- (NSString *)tabTitle;

@end
