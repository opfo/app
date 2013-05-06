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

@implementation OPFProfileSearchViewController {
	BOOL _isFirstTimeAppearing;
}

//Used for initial fetch and any susequent call
#define OPF_PAGE_SIZE 25

static NSString *const ProfileHeaderViewIdentifier = @"OPFProfileSearchHeaderView";
static NSString *ProfileViewCellIdentifier = @"OPFProfileViewCell";

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
	
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFProfileViewCell) bundle:nil] forCellReuseIdentifier:ProfileViewCellIdentifier];
	
    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (_isFirstTimeAppearing) {
		_isFirstTimeAppearing = NO;
		
		BOOL isSearchingAndHasRows = (self.isSearching) && self.mutableUserModels.count > 0;
		BOOL isNotSearchingAndHasRows = (self.isSearching) == NO && self.mutableUserModels.count > 0;
		if (isSearchingAndHasRows || isNotSearchingAndHasRows) {
			CGPoint offsetPoint = CGPointMake(0, CGRectGetHeight(self.profileSearchBar.bounds));
			[self.tableView setContentOffset:offsetPoint animated:NO];
		}
	}
}

- (void)opfSetupView
{
	_isFirstTimeAppearing = YES;
    [self performInitialDatabaseFetch];
    
    self.title = NSLocalizedString(@"User search", @"Profile search controller title");
}

#pragma mark - TabbedViewController methods

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"tab-searchprofiles";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return NSLocalizedString(@"Users", @"Profile search controller tab title");
}

- (void)performInitialDatabaseFetch
{
    self.atPage = [NSNumber numberWithInt:0];

    self.mutableUserModels = [NSMutableArray arrayWithArray:[OPFUser all:[self.atPage integerValue] per:OPF_PAGE_SIZE]];
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
    
    int index = self.mutableUserModels.count - indexPath.row - 1;
        
    userModel = index >= 0 ? self.mutableUserModels[index]: nil;

    return userModel;
}

- (void)didSelectUserWebsite:(UIButton *)sender;
{
    //Only open valid urls
    NSURL *websiteUrl = [NSURL URLWithString:sender.titleLabel.text];
    
    if (websiteUrl != nil) {
        [[UIApplication sharedApplication] openURL:websiteUrl];
    }
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
    return self.mutableUserModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OPFProfileViewCell *profileViewCell = (OPFProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:ProfileViewCellIdentifier forIndexPath:indexPath];
    
    profileViewCell.userModel = [self userForIndexPath:indexPath];
    
    [profileViewCell setupFormatters];
    [profileViewCell setModelValuesInView];
    
    profileViewCell.profilesViewController = self;
    
    return profileViewCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.contentView.backgroundColor = UIColor.whiteColor;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	OPFUser *userModel = [self userForIndexPath:indexPath];
	OPFUserProfileViewController *userProfileViewController = OPFUserProfileViewController.newFromStoryboard;
    userProfileViewController.user = userModel;
    
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.profileSearchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.isSearching = (searchText.length == 0) ? NO : YES;
    
    self.databaseUserModels =  [[OPFUser searchFor:searchText] getMany];
    
    if(self.isSearching) {
        self.hasLoaded = NO;
                
        self.mutableUserModels = [NSMutableArray arrayWithArray:self.databaseUserModels];
    } else {
        [self searchBarSearchButtonClicked:searchBar];
    }
    
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:NO animated:YES];
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.hasLoaded = self.isSearching = NO;
    [self updateSearchWithString:@""];
    
    [self performInitialDatabaseFetch];
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)updateSearchWithString:(NSString *)searchString
{
	self.profileSearchBar.text = searchString;
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