//
//  OPFDebugViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 23.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFDebugViewController.h"
#import "OPFCommentsViewController.h"
#import "OPFProfileSearchViewController.h"
#import "OPFQuestionsViewController.h"
#import "OPFUserProfileViewController.h"

enum {
	kOPFQuestionsViewCell = 0,
	kOPFQuestionViewCell = 1,
	kOPFUserProfileViewCell = 2,
	kOPFProfileSearchViewCell = 3,
	kOPFCommentsViewCell = 4,
};

@interface OPFDebugViewController ()

@property(nonatomic, strong) NSArray *tableViewCells;

@end

@implementation OPFDebugViewController

#pragma mark - Reuse Identifiers
static NSString *const QuestionsViewCell = @"QuestionsViewCell";
static NSString *const QuestionViewCell = @"QuestionViewCell";
static NSString *const UserProfileViewCell = @"UserProfileViewCell";
static NSString *const ProfileSearchViewCell = @"ProfileSearchViewCell";
static NSString *const CommentsViewCell = @"CommentsViewCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
    }
    
    return self;
}

- (void)addCellOutletsToCellArray
{
    self.tableViewCells = [NSArray arrayWithObjects:self.questionsViewCell, self.questionViewCell, self.userProfileViewCell, self.userProfileSearchViewCell, self.commentsViewCell, nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    
    switch (indexPath.row) {
        case kOPFUserProfileViewCell:
            cellIdentifier = UserProfileViewCell;
            break;
        case kOPFProfileSearchViewCell:
            cellIdentifier = ProfileSearchViewCell;
            break;
        case kOPFCommentsViewCell:
            cellIdentifier = CommentsViewCell;
            break;
		case kOPFQuestionsViewCell:
			cellIdentifier = QuestionsViewCell;
			break;
		case kOPFQuestionViewCell:
			cellIdentifier = QuestionViewCell;
			break;
		default:
			cellIdentifier = nil;
			break;
    }
    
    return cellIdentifier;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self addCellOutletsToCellArray];
    
    return [self.tableViewCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewCells objectAtIndex:indexPath.item];
}

#pragma mark - Table view delegate

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewToPush = nil;
    
    if ([[self cellIdentifierForIndexPath:indexPath] isEqualToString:CommentsViewCell]) {
        viewToPush = OPFCommentsViewController.new;
    } else if ([[self cellIdentifierForIndexPath:indexPath] isEqualToString:ProfileSearchViewCell]) {
        viewToPush = OPFProfileSearchViewController.new;
    } else if ([[self cellIdentifierForIndexPath:indexPath] isEqualToString:QuestionsViewCell]) {
		viewToPush = OPFQuestionsViewController.new;
	}
	
    if (viewToPush) {
		[self.navigationController pushViewController:viewToPush animated:YES];
	}
}

// Send the data to the detailViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    if ([[segue identifier] isEqualToString:@"ShowUserProfileView"]) {
        OPFUserProfileViewController *profileViewController = [segue destinationViewController];
        NSArray *users = [[[OPFUser query] whereColumn:@"display_name" like:@"Matt"] getMany];
        profileViewController.user = [users objectAtIndex:0];
    }
}

@end
