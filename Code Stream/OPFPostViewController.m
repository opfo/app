//
//  OPFPostViewController.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 16-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostViewController.h"


enum : NSInteger {
	kOFPPostViewBodyCellRow = 0,
	kOFPPostViewMetadataCellRow = 1,
	kOFPPostViewTagsCellRow = 2,
	kOFPPostViewCommentsCellRow = 3,
};


@interface OPFPostViewController ()
@end

@implementation OPFPostViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	UINib *nib = [UINib nibWithNibName:@"OPFPostViewController" bundle:NSBundle.mainBundle];
	[self.tableView registerNib:nib forCellReuseIdentifier:@"BodyCell"];
	[self.tableView registerNib:nib forCellReuseIdentifier:@"MetadataCell"];
	[self.tableView registerNib:nib forCellReuseIdentifier:@"TagsCell"];
	[self.tableView registerNib:nib forCellReuseIdentifier:@"CommentsCell"];
	
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

// FIXME: Known error this needs to fixed.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *BodyCellIdentifier = @"BodyCell";
	static NSString *MetadataCellIdentifier = @"MetadataCell";
	static NSString *TagsCellIdentifier = @"TagsCell";
	static NSString *CommentsCellIdentifier = @"CommentsCell";
	
	NSString *cellIdentifier = nil;
	switch (indexPath.row) {
		case kOFPPostViewBodyCellRow: cellIdentifier = BodyCellIdentifier; break;
		case kOFPPostViewMetadataCellRow: cellIdentifier = MetadataCellIdentifier; break;
		case kOFPPostViewTagsCellRow: cellIdentifier = TagsCellIdentifier; break;
		case kOFPPostViewCommentsCellRow: cellIdentifier = CommentsCellIdentifier; break;
		default: NSAssert(NO, @"Unknown index path row %d", indexPath.row); break;
	}
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
