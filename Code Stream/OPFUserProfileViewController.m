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
#import "OPFAppDelegate.h"
#import "UIImageView+KHGravatar.h"
#import "UIImageView+AFNetworking.h"
#import "OPFScoreNumberFormatter.h"
#import "OPFQuestion.h"
#import "OPFAnswer.h"

enum  {
    kOPFUserQuestionsViewCell = 4,
    kOPFUserAnswersViewCell = 5
};

@interface OPFUserProfileViewController ()

@property(nonatomic, strong) OPFScoreNumberFormatter *scoreFormatter;
@property(nonatomic, strong) NSNumberFormatter *numberFormatter;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

- (void)loadUserGravatar;
- (void)setAvatarWithGravatar :(UIImage*) gravatar;

@end

@implementation OPFUserProfileViewController

// Identifiers for the questions and view cells
static NSString *const UserQuestionsViewCell = @"UsersQuestionsViewCell";
static NSString *const UserAnswersViewCell = @"UserAnswersViewCell";

static CGFloat userAboutMeInset = 20.0;

+ (instancetype)newFromStoryboard
{
	// This be a hack, do not ship stuff like this!
	NSAssert(OPFAppDelegate.sharedAppDelegate.window.rootViewController.storyboard != nil, @"Our hack to instantiate OPFUserProfileViewController from the storyboard failed as the root view controller wasn’t from the storyboard.");
	OPFUserProfileViewController *userProfileViewController = [OPFAppDelegate.sharedAppDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
	return userProfileViewController;
}

-(id) init
{
	self = [super init];
    if (self) {
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
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

- (void)loadUserGravatar
{
    __weak OPFUserProfileViewController *weakSelf = self;
    
    [self.userAvatar setImageWithGravatarEmailHash:self.user.emailHash placeholderImage:weakSelf.userAvatar.image defaultImageType:KHGravatarDefaultImageMysteryMan rating:KHGravatarRatingX
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [weakSelf setAvatarWithGravatar:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 
    }];
}

- (void)setAvatarWithGravatar :(UIImage*) gravatar
{
    self.userAvatar.image = gravatar;
}

-(void) configureView
{
    self.scoreFormatter = [OPFScoreNumberFormatter new];
    self.numberFormatter = [NSNumberFormatter new];
    self.dateFormatter = [NSDateFormatter new];
    
    // Set the textFields in the userInterface
    self.userName.text = self.user.displayName;
    //self.userAboutMe.text = self.user.aboutMe;
    self.userLocation.text = self.user.location;
    self.userWebsite.text = [self.user.websiteUrl absoluteString];
    [self loadUserGravatar];
    
    //Set number-fields by using a NSNumberFormatter and OPFScoreNumberFormatter
    self.userReputation.text = [self.scoreFormatter stringFromScore:[self.user.reputation integerValue]];;
    self.userAge.text = [self.numberFormatter stringFromNumber:self.user.age];
    
    // Set date-fields by using a NSDateFormatter
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.userCreationDate.text = [self.dateFormatter stringFromDate:self.user.creationDate];
    self.userLastAccess.text = [self.dateFormatter stringFromDate:self.user.lastAccessDate];
    
    [self.userBio loadHTMLString:[NSString stringWithFormat:@"<font face='Helvetica' size='2'>%@", self.user.aboutMe] baseURL:nil];
    
    
    self.userVotes.text = [[[self.user.upVotes stringValue] stringByAppendingString:@"/"] stringByAppendingString:[self.user.downVotes stringValue]];
    self.views.text = [self.user.view stringValue];
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
-(NSString *) cellIdentifierForIndexPath: (NSIndexPath *) indexPath
{
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
       
        OPFQuestionsViewController *questionsViewController = [OPFQuestionsViewController new];
       
        NSMutableArray *questions = [[[OPFQuestion query] whereColumn:@"owner_user_id" is:self.user.identifier] getMany].mutableCopy;

        questionsViewController.questions=questions;
        detailViewController =[OPFQuestionsViewController new];
    }
    // To be implemented
    else if ([[self cellIdentifierForIndexPath:indexPath] isEqualToString:UserAnswersViewCell]){
        
        /*NSMutableArray *questions = [[[OPFAnswer query] whereColumn:@"owner_user_id" is:self.user.identifier] getMany].mutableCopy;*/
        
        detailViewController = nil;
    }
    
    // Pass the selected object to the new view controller.
    if(detailViewController!=nil){
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}



@end
