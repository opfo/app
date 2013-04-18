//
//  OPFCommentViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFCommentsViewController.h"
#import "OPFCommentViewCell.h"
#import "OPFCommentViewHeaderView.h"

@interface OPFCommentsViewController ()

@end

@implementation OPFCommentsViewController

- (id)init
{
    self = [super initWithNibName:@"OPFCommentsViewTable" bundle:nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    static NSString *commentViewCellIdentifier = @"OPFCommentViewCell";
        
    OPFCommentViewCell *commentViewCell = (OPFCommentViewCell *)[tableView dequeueReusableCellWithIdentifier:commentViewCellIdentifier];
    
    if (commentViewCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:commentViewCellIdentifier owner:self options:nil];
        commentViewCell = [nib objectAtIndex:0];
    }
    
    commentViewCell.commentModel = [self.commentModels objectAtIndex:indexPath.row];
    
    [commentViewCell setupDateformatters];
    [commentViewCell setModelValuesInView];
    
    commentViewCell.commentsViewController = self;
    
    return commentViewCell;
}

- (void)voteUpComment:(UIButton *)sender
{
    OPFCommentViewCell *subordinateCommentViewCell = (OPFCommentViewCell *)[[sender superview] superview];
    NSIndexPath *indexPathOfCommentViewCell = [commentTableView indexPathForCell:subordinateCommentViewCell];
    
    NSLog(@"%@",indexPathOfCommentViewCell);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OPFCommentViewHeaderView *commentViewHeader = [OPFCommentViewHeaderView new];
    
    commentViewHeader.postModel = self.postModel;
    
    [commentViewHeader setupDateformatters];
    [commentViewHeader setModelValuesInView];
    
    return commentViewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
