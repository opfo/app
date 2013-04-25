//
//  OPFUserProfileViewController.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-04-25.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUserProfileViewController.h"
#import "OPFUser.h"
@interface OPFUserProfileViewController ()

@end

@implementation OPFUserProfileViewController

static CGFloat userAboutMeInset = 100.0;

-(id) init{
    if (self) {
       self = [super init];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    
    _user = [[OPFUser alloc] init];
    [_user setDisplayName:@"Marcus"];
    [_user setReputation:@1367];
    [_user setLastAccessDate:[[NSDate alloc] init]];
    [_user setAboutMe:@"I'm a developer who works with java.I'm a developer who works with java.I'm a developer who works with java.I'm a developer who works with java.I'm a developer who works with java.I'm a developer who works with java.I'm a developer who works with java.I'm a developer who works with java.I'm a developer who works with java.I'm a developer who works with java."];
    [_user setLocation:@"Gothenburg, Sweden"];
    [_user setAge:@23];
    [_user setWebsiteUrl:[[[NSURL alloc] init] initWithString:@"www.chalmers.se"]];
    
    self.userDisplayName.text = _user.displayName;
    self.userAboutMe.text = _user.aboutMe;
    self.userLocation.text = _user.location;
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    self.userReputation.text = [numberFormatter stringFromNumber:_user.reputation];
    
    self.userAge.text = [numberFormatter stringFromNumber:_user.age];
    

    
    self.userWebsite.text = [_user.websiteUrl absoluteString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.userCreationDate.text = [formatter stringFromDate:_user.creationDate];
    self.userLastAccess.text = [formatter stringFromDate:_user.lastAccessDate];

    
}

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


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 0.f;
    
    if(indexPath.section==1 && indexPath.row == 0){
        NSString *aboutUser = _user.aboutMe;
        UIFont *aboutUserFont = [UIFont systemFontOfSize:14.f];
        CGSize constrainmentSize = CGSizeMake(CGRectGetWidth(tableView.bounds), 99999999.f);
        CGSize aboutUserSize = [aboutUser sizeWithFont:aboutUserFont constrainedToSize:constrainmentSize lineBreakMode:NSLineBreakByWordWrapping];
        height = aboutUserSize.height + userAboutMeInset;
    }
    else
    {
        height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return height;
}



#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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
//}

@end
