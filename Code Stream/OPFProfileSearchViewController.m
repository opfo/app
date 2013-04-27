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
#import "OPFAppDelegate.h"

@interface OPFProfileSearchViewController ()

@property(strong, nonatomic) NSMutableArray *mutableUserModels;
@property(strong, nonatomic) NSArray *databaseUserModels;
@property(nonatomic) BOOL hasLoaded;
@property(nonatomic) BOOL isSearching;

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

- (void)performInitialDatabaseFetch
{
    self.atPage = [NSNumber numberWithInt:0];

    self.rootUserModels = [OPFUser all:[self.atPage integerValue] per:OPF_PAGE_SIZE];
    self.mutableUserModels = [NSMutableArray arrayWithArray:self.rootUserModels];
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
    OPFUser *userModel = nil;
    
    if(self.hasLoaded || self.isSearching) {
        int index = self.mutableUserModels.count - indexPath.row - 1;
        
        userModel = index > 0 ? self.mutableUserModels[index]: nil;
    } else {
        int index = self.rootUserModels.count - indexPath.row - 1;

        userModel = self.rootUserModels[index];
    }
    
    return userModel;
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
    return self.hasLoaded ? self.mutableUserModels.count : self.rootUserModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *profileViewCellIdentifier = @"OPFProfileViewCell";
    
    OPFProfileViewCell *profileViewCell = (OPFProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:profileViewCellIdentifier];
    
    if (profileViewCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:profileViewCellIdentifier owner:self options:nil];
        profileViewCell = [nib objectAtIndex:0];
    }
        
    profileViewCell.userModel = [self userForIndexPath:indexPath];
    
    [profileViewCell setupFormatters];
    [profileViewCell setModelValuesInView];
    
    profileViewCell.profilesViewController = self;
    
    return profileViewCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// This be a hack, do not ship stuff like this!
	NSAssert(OPFAppDelegate.sharedAppDelegate.window.rootViewController.storyboard != nil, @"Our hack to instantiate OPFUserProfileViewController from the storyboard failed as the root view controller wasn’t from the storyboard.");
	OPFUserProfileViewController *userProfileViewController = [self.view.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];

	OPFUser *userModel = [self userForIndexPath:indexPath];
    userProfileViewController.user = userModel;
    
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

#pragma mark - SearchBar Delegate -
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.isSearching = (searchText.length == 0) ? NO : YES;
    
    self.databaseUserModels = [[[OPFUser query] whereColumn:@"display_name" like:searchText] getMany];
    
    if(self.isSearching) {
        self.hasLoaded = NO;
        
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
    //All results have been loaded, nothing to fetch
    if (self.isSearching) {
        [(UIRefreshControl *)sender endRefreshing];
        return; 
    }
    
    self.atPage = [NSNumber numberWithInteger:[self.atPage integerValue] + 1];
    
    self.hasLoaded = YES;
    
    NSArray *fetchedModels = [OPFUser all:[self.atPage integerValue] per:OPF_PAGE_SIZE];
    
    [self.mutableUserModels addObjectsFromArray:fetchedModels];
    
    [self.tableView reloadData];
    
    [(UIRefreshControl *)sender endRefreshing];
}

@end