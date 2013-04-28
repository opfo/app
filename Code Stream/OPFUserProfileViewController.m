//
//  OPFUserProfileViewController.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-04-25.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFUserProfileViewController.h"
#import "OPFUser.h"
#import "OPFQuestionsViewController.h"

enum  {
    kOPFUserQuestionsViewCell = 4,
    kOPFUserAnswersViewCell = 5
    };

@interface OPFUserProfileViewController ()
@end

@implementation OPFUserProfileViewController

// Identifiers for the questions and view cells
static NSString *const UserQuestionsViewCell = @"UsersQuestionsViewCell";
static NSString *const UserAnswersViewCell = @"UserAnswersViewCell";

static CGFloat userAboutMeInset = 50.0;

-(id) init{
    if (self) {
       self = [super init];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    // Configure the view according to the userdata
    [self configureView];
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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) configureView{
    // Set the textFields in the userInterface
    self.userDisplayName.text = _user.displayName;
    self.userAboutMe.text = _user.aboutMe;
    self.userLocation.text = _user.location;
    self.userWebsite.text = [_user.websiteUrl absoluteString];
    
    //Set number-fields by using a NSNumberFormatter
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    self.userReputation.text = [numberFormatter stringFromNumber:_user.reputation];
    self.userAge.text = [numberFormatter stringFromNumber:_user.age];
    
    // Set date-fields by using a NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.userCreationDate.text = [formatter stringFromDate:_user.creationDate];
    NSLog(@"Created? ");
    NSLog(self.userCreationDate.text);
    self.userLastAccess.text = [formatter stringFromDate:_user.lastAccessDate];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Autoresize the "About Me" textview
    CGFloat height = 0.f;
    
    if(indexPath.section==1 && indexPath.row == 0){
        NSString *aboutUser = _user.aboutMe;
        UIFont *aboutUserFont = [UIFont systemFontOfSize:14.f];
        CGSize constrainmentSize = CGSizeMake(CGRectGetWidth(tableView.bounds), 99999999.f);
        CGSize aboutUserSize = [aboutUser sizeWithFont:aboutUserFont constrainedToSize:constrainmentSize lineBreakMode:NSLineBreakByWordWrapping];
        height = aboutUserSize.height + userAboutMeInset;
    }
    // Set all the other tables to the default height
    else
    {
        height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return height;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

// Indentify which cell the user clicked on
-(NSString *) cellIdentifierForIndexPath: (NSIndexPath *) indexPath{
    NSString *cellIdentifier = nil;
    
    if(indexPath.section==4){
        if(indexPath.row==0)
            cellIdentifier = UserQuestionsViewCell;
        else if(indexPath.row==1)
        cellIdentifier = UserAnswersViewCell;
    }
    return cellIdentifier;
}

// THIS METHOD IS NOT COMPLETE, NEED TO BE CONNECTED TO THE QUESTIONSVIEW FIRST.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIViewController *detailViewController = nil;
    if([[self cellIdentifierForIndexPath:indexPath]isEqualToString:UserQuestionsViewCell]){
        detailViewController =[OPFQuestionsViewController new];
    }
    // To be implemented
    else if ([[self cellIdentifierForIndexPath:indexPath] isEqualToString:UserAnswersViewCell]){
        detailViewController = nil;
    }
    // ...
    // Pass the selected object to the new view controller.
    if(YES){//detailViewController){
        [self.navigationController pushViewController:detailViewController animated:YES];
    }

    
}


#pragma mark - Table view data source

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"Cell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
*/



@end
