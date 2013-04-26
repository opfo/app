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
#import "UIView+OPFViewLoading.h"
#import "OPFUserProfileViewController.h"

@interface OPFProfileSearchViewController ()

@property(strong, nonatomic) NSMutableArray *mutableUserModels;
@property(strong, nonatomic) NSArray *databaseUserModels;
@property(nonatomic) BOOL isFiltered;

- (void)performInitialDatabaseFetch;
- (void)setupRefreshControl;
- (void)opfSetupView;

@end

@implementation OPFProfileSearchViewController

//Used for initial fetch and any susequent call
#define OPF_PAGE_SIZE 25

static NSString *const ProfileHeaderViewIdentifier = @"OPFProfileSearchHeaderView";

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
    
    [self setupRefreshControl];
}

- (void)opfSetupView
{    
    [self performInitialDatabaseFetch];
}

- (void)insertRowsAtBottom {
    self.isFiltered = YES;
    self.atPage = [NSNumber numberWithInt:[self.atPage integerValue] + 1];
}

- (void)performInitialDatabaseFetch
{
    self.atPage = [NSNumber numberWithInt:0];

    self.rootUserModels = [OPFUser all:[self.atPage integerValue] per:OPF_PAGE_SIZE];
}

- (void)setupRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (OPFUser *)userForIndexPath:(NSIndexPath *)indexPath
{
    return self.isFiltered ? self.mutableUserModels[indexPath.section] : self.rootUserModels[indexPath.section];
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
    return self.isFiltered ? self.mutableUserModels.count : self.rootUserModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *profileViewCellIdentifier = @"OPFProfileViewCell";
    
    OPFProfileViewCell *profileViewCell = (OPFProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:profileViewCellIdentifier];
    
    if (profileViewCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:profileViewCellIdentifier owner:self options:nil];
        profileViewCell = [nib objectAtIndex:0];
    }
        
    profileViewCell.userModel
    = (self.isFiltered == YES) ? [self.mutableUserModels objectAtIndex:indexPath.row] : [self.rootUserModels objectAtIndex:indexPath.row];
    
    [profileViewCell setupFormatters];
    [profileViewCell setModelValuesInView];
    
    profileViewCell.profilesViewController = self;
    
    return profileViewCell;
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading profiles…"];
    
    [refresh endRefreshing];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OPFUser *userModel = [self userForIndexPath:indexPath];
    OPFUserProfileViewController *userProfileViewController = [OPFUserProfileViewController new];
    
    userProfileViewController.user = userModel;
    
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

#pragma mark - SearchBar Delegate -
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.isFiltered = (searchText.length == 0) ? NO : YES;
    
    self.databaseUserModels = [[[OPFUser query] whereColumn:@"display_name" like:searchText] getMany];
    
    if(self.isFiltered) {
        [self.mutableUserModels removeAllObjects];
        
        self.profilePredicate = [NSPredicate predicateWithFormat:@"displayName BEGINSWITH[cd] %@", searchText];
                
        self.mutableUserModels = [NSMutableArray arrayWithArray:[self.databaseUserModels filteredArrayUsingPredicate:self.profilePredicate]];
    } else {
        [self searchBarSearchButtonClicked:searchBar];
    }
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UIRefreshControl delegates

- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

@end