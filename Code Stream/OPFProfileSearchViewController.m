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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
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
    
    profileViewCell.commentModel = [self.commentModels objectAtIndex:indexPath.row];
    
    [commentViewCell setupDateformatters];
    [commentViewCell setModelValuesInView];
    
    commentViewCell.commentsViewController = self;
    
    return commentViewCell;
}

@end
