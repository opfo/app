//
//  OPFProfileSearchViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFUser;

@interface OPFProfileSearchViewController : UITableViewController <UISearchBarDelegate>

@property(nonatomic, strong) NSPredicate *profilePredicate;
@property(nonatomic, assign) NSNumber *atPage;

@property (weak, nonatomic) IBOutlet UISearchBar *profileSearchBar;

- (IBAction)didSelectUserWebsite:(UIButton *)sender;

@end