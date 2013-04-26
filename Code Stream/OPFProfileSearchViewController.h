//
//  OPFProfileSearchViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFUser;

@interface OPFProfileSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(nonatomic, strong) NSArray *rootUserModels;
@property(nonatomic, strong) NSPredicate *profilePredicate;
@property(nonatomic, assign) NSNumber *atPage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *profileSearchBar;

@end