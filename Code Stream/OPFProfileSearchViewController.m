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
#import "OPFUser.h"

@interface OPFProfileSearchViewController ()

@property (strong, nonatomic) NSMutableArray *mutableUserModels;
@property(nonatomic) BOOL isFiltered;

- (void)performInitialDatabaseFetch;
- (void)opfSetupView;

@end

@implementation OPFProfileSearchViewController

- (id)init
{
    self = [super initWithNibName:@"OPFProfileSearchView" bundle:nil];

    if(self) {
        [self opfSetupView];
    }
   
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)opfSetupView
{
    [self performInitialDatabaseFetch];
}

- (void)performInitialDatabaseFetch
{
    self.userModels = [OPFUser all];
    
    OPFUser *firstUser = [self.userModels objectAtIndex:0];
    
    NSLog(@"%@", firstUser);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Returning 1 because we only have one section for users
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isFiltered ? self.mutableUserModels.count : self.userModels.count;
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
    
    [profileViewCell setupFormatters];
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