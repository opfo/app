//
//  OPFQuestionsViewController.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsViewController.h"
#import "OPFSingleQuestionPreviewCell.h"
#import "OPFQuestion+Mockup.h"


@interface OPFQuestionsViewController (/*Private*/)
#pragma mark - Presented Data
@property (strong) NSMutableArray *questions;
@property (strong) NSMutableArray *filteredQuestions;

- (void)reloadQuestions;

#pragma mark - Searching
@end


// It should be possible to search for:
// - Keywords (free text, search in title and body)
// - Tags (match exactly)

@implementation OPFQuestionsViewController

#pragma mark - Cell Identifiers
static NSString *const QuestionCellIdentifier = @"QuestionCell";
static NSString *const SearchQuestionsCellIdentifier = @"SearchQuestionCell";

#pragma mark - Object Lifecycle
- (void)sharedQuestionsViewControllerInit
{
	_questions = NSMutableArray.new;
	_filteredQuestions = NSMutableArray.new;
}

- (id)init
{
	self = [super init];
	if (self) [self sharedQuestionsViewControllerInit];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) [self sharedQuestionsViewControllerInit];
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) [self sharedQuestionsViewControllerInit];
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) [self sharedQuestionsViewControllerInit];
	return self;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.searchDisplayController.searchBar.placeholder = NSLocalizedString(@"Search questions and answers…", @"Search questions and answers placeholder text");
	
	[self.tableView registerNib:[UINib nibWithNibName:@"SingleQuestionPreviewCell" bundle:nil] forCellReuseIdentifier:QuestionCellIdentifier];
	[self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SingleQuestionPreviewCell" bundle:nil] forCellReuseIdentifier:SearchQuestionsCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Fetch all questions matching our current search limits.
	// TEMP:
	for (NSInteger i = 0; i < 5; ++i) {
		[self.questions addObject:OPFQuestion.generatePlaceholderQuestion];
	}
	[self.filteredQuestions setArray:self.questions];
	[self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = nil;
	OPFQuestion *question = nil;
	if (tableView == self.tableView) {
		cellIdentifier = QuestionCellIdentifier;
		question = self.questions[indexPath.row];
	} else {
		cellIdentifier = SearchQuestionsCellIdentifier;
		question = self.filteredQuestions[indexPath.row];
	}
	
	OPFSingleQuestionPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	[cell configureWithQuestionData:question];
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 150;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	/*
	 DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 */
}

@end
