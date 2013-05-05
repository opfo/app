//
//  OPFActivityViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 30.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFActivityViewController.h"
#import "OPFAppState.h"
#import "OPFQuery.h"
#import "OPFQuestion.h"
#import "OPFAnswer.h"
#import "OPFComment.h"
#import "OPFActivityQuestionViewCell.h"
#import "OPFActivityAnswerViewCell.h"
#import "OPFActivityCommentViewCell.h"
#import "OPFQuestionViewController.h"
#import "OPFCommentsViewController.h"

@interface OPFActivityViewController ()

@property(strong, nonatomic) NSArray *questionModels;
@property(strong, nonatomic) NSArray *answerModels;
@property(strong, nonatomic) NSArray *commentModels;

enum {
	kOPFActivityQuestionSection = 0,
	kOPFActivityAnswerSection = 1,
	kOPFActivityCommentSection = 3
};

@end

@implementation OPFActivityViewController

static NSString *const OPFActivityQuestionViewCellIdentifier = @"OPFActivityQuestionViewCell";
static NSString *const OPFActivityAnswerViewCellIdentifier = @"OPFActivityAnswerViewCell";
static NSString *const OPFActivityCommentViewCellIdentifier = @"OPFActivityCommentViewCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self opfSetupView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self fetchModels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)opfSetupView
{
    self.title = NSLocalizedString(@"Latest activity", @"Activity View controller title");
}

- (void)fetchModels
{
    if (![OPFAppState isLoggedIn]) { return; }
    
    OPFQuery *questionsQuery = nil;
    OPFQuery *answersQuery = nil;
    OPFQuery *commentsQuery = nil;
    
    questionsQuery = [[[OPFQuestion.query whereColumn:@"owner_user_id" is:[OPFAppState userModel].identifier] orderBy:@"last_activity_date" order:kOPFSortOrderAscending] limit:@(25)];
    answersQuery = [[[OPFAnswer.query whereColumn:@"owner_user_id" is:[OPFAppState userModel].identifier] orderBy:@"last_activity_date" order:kOPFSortOrderAscending] limit:@(25)];
    commentsQuery = [[[OPFComment.query whereColumn:@"user_id" is:[OPFAppState userModel].identifier] orderBy:@"creation_date" order:kOPFSortOrderAscending] limit:@(25)];
    
    self.questionModels = [self.questionModels initWithArray:[questionsQuery getMany]];
    self.answerModels = [self.answerModels initWithArray:[answersQuery getMany]];
    self.answerModels = [self.answerModels initWithArray:[commentsQuery getMany]];
}

#pragma mark - TabbedViewController methods

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"tab-latestactivity";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return NSLocalizedString(@"Activity", @"Activity View controller tab title");
}

- (OPFModel *)modelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kOPFActivityQuestionSection) { return [self.questionModels objectAtIndex:indexPath.row]; }
    else if (indexPath.section == kOPFActivityAnswerSection) { return [self.answerModels objectAtIndex:indexPath.row]; }
    else if (indexPath.section == kOPFActivityCommentSection) { return [self.commentModels objectAtIndex:indexPath.row]; }
    
    else { return nil; }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kOPFActivityQuestionSection) { return [self.questionModels count]; }
    else if (section == kOPFActivityAnswerSection) { return [self.answerModels count]; }
    else if (section == kOPFActivityCommentSection) { return [self.commentModels count]; }
    
    else { return 0; }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kOPFActivityQuestionSection) {
        
        OPFActivityQuestionViewCell *cell = (OPFActivityQuestionViewCell *)[tableView dequeueReusableCellWithIdentifier:OPFActivityQuestionViewCellIdentifier forIndexPath:indexPath];
        
        cell.questionModel = (OPFQuestion *)[self modelForIndexPath:indexPath];
        
    } else if (indexPath.section == kOPFActivityAnswerSection) {
        
        OPFActivityAnswerViewCell *cell = (OPFActivityAnswerViewCell *)[tableView dequeueReusableCellWithIdentifier:OPFActivityAnswerViewCellIdentifier forIndexPath:indexPath];
        
        cell.answerModel = (OPFAnswer *)[self modelForIndexPath:indexPath];
        
    } else if (indexPath.section == kOPFActivityCommentSection) {
        
        OPFActivityCommentViewCell *cell = (OPFActivityCommentViewCell *)[tableView dequeueReusableCellWithIdentifier:OPFActivityCommentViewCellIdentifier forIndexPath:indexPath];
        
        cell.commentModel = (OPFComment *)[self modelForIndexPath:indexPath];
        
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == kOPFActivityQuestionSection) { return NSLocalizedString(@"Questions", @"Question section header in activity table view"); }
    else if (section == kOPFActivityAnswerSection) { return NSLocalizedString(@"Answers", @"Answer section header in activity table view"); }
    else if (section == kOPFActivityCommentSection) { return NSLocalizedString(@"Comments", @"Comment section header in activity table view"); }
    
    else { return NSLocalizedString(@"", @"Unknown section in activity table view"); }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kOPFActivityQuestionSection || indexPath.section == kOPFActivityAnswerSection) {
        
        OPFQuestion *questionModel = (OPFQuestion *)[self modelForIndexPath:indexPath];
        OPFQuestionViewController *questionViewController = [OPFQuestionViewController new];
        questionViewController.question = questionModel;
        
        [self.navigationController pushViewController:questionViewController animated:YES];
        
    }  else if (indexPath.section == kOPFActivityCommentSection) {
        
        OPFComment *commentModel = (OPFComment *)[self modelForIndexPath:indexPath];
        OPFCommentsViewController *commentViewController = [OPFCommentsViewController new];
        commentViewController.postModel = commentModel.post;
        
        [self.navigationController pushViewController:commentViewController animated:YES];
        
    }
}

@end
