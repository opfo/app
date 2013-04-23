//
//  OPFProfileSearchViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFProfileSearchViewController.h"
#import "OPFProfileViewCell.h"

@interface OPFProfileSearchViewController ()

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
	// Do any additional setup after loading the view.
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

@end
