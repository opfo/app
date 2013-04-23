//
//  OPFProfileSearchViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFProfileSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(nonatomic, strong) NSArray *userModels;
@property(nonatomic, strong) NSPredicate *profilePredicate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UISearchBar *profileSearchBar;

@end