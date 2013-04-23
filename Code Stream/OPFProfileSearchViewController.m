//
//  OPFProfileSearchViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFProfileSearchViewController.h"
#import "OPFProfileViewCell.h"
#import "OPFProfileSearchHeaderView.h"

@interface OPFProfileSearchViewController ()

@property (strong, nonatomic) NSMutableArray *mutableUserModels;
@property(nonatomic) BOOL isFiltered;

@end

@implementation OPFProfileSearchViewController

- (id)init
{
    self = [super initWithNibName:@"OPFProfileSearchView" bundle:nil];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        //init goes here mofo
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setUserModels:(NSArray *)userModels
{
    self.userModels = userModels;
    self.mutableUserModels = [NSMutableArray arrayWithCapacity:self.userModels.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Returning 1 because we only display one post's comments
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.isFiltered ? self.mutableUserModels.count : self.userModels.count;
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OPFProfileSearchHeaderView *profileViewHeader = [OPFProfileSearchHeaderView new];
    
    self.profileSearchBar = profileViewHeader.profileSearchBar;
    
    self.profileSearchBar.delegate = (id)self;
    
    return profileViewHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *profileViewCellIdentifier = @"OPFProfileViewCell";
    
    OPFProfileViewCell *profileViewCell = (OPFProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:profileViewCellIdentifier];
    
    if (profileViewCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:profileViewCellIdentifier owner:self options:nil];
        profileViewCell = [nib objectAtIndex:0];
    }
    
    profileViewCell.userModel = [self.userModels objectAtIndex:indexPath.row];
    
    [profileViewCell setupDateformatters];
    [profileViewCell setModelValuesInView];
    
    profileViewCell.profilesViewController = self;
    
    return profileViewCell;
}

#pragma mark - SearchBar Delegate -
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.isFiltered = (searchText.length == 0) ? NO : YES;
    
    [self.mutableUserModels removeAllObjects];

    self.profilePredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    
    self.mutableUserModels = [NSMutableArray arrayWithArray:[self.userModels filteredArrayUsingPredicate:self.profilePredicate]];
    
    [self.tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBar button clicked");
}

@end