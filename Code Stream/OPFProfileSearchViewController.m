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

@end

@implementation OPFProfileSearchViewController

- (id)init
{
    self = [super initWithNibName:@"OPFProfileSearchView" bundle:nil];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Shall return the number of items in data source
    //return self.commentModels.count;
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OPFProfileSearchHeaderView *profileViewHeader = [OPFProfileSearchHeaderView new];
    
    self.profileSearchBar = profileViewHeader.profileSearchBar;
    
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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.mutableUserModels removeAllObjects];

    self.profilePredicate = [NSPredicate predicateWithFormat:@"SELF.displayName contains[c] %@", searchText];
    
    self.mutableUserModels = [NSMutableArray arrayWithArray:[self.userModels filteredArrayUsingPredicate:self.profilePredicate]];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
