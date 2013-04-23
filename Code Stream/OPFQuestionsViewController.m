//
//  OPFQuestionsViewController.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsViewController.h"
#import "OPFSingleQuestionPreviewCell.h"
#import "OPFQuestionViewController.h"
#import "OPFQuestion.h"
#import "OPFQuestion+Mockup.h"
#import "NSString+OPFStripCharacters.h"


@interface OPFQuestionsViewController (/*Private*/)
#pragma mark - Presented Data
@property (copy) NSArray *questions;
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
	_questions = NSArray.new;
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
	[self addObserver:self forKeyPath:CDStringFromSelector(searchString) options:0 context:NULL];
	
	// Fetch all questions matching our current search limits.
	// TEMP:
	NSMutableArray *questions = NSMutableArray.new;
	for (NSInteger i = 0; i < 5; ++i) {
		[questions addObject:OPFQuestion.generatePlaceholderQuestion];
	}
	self.questions = questions;
	[self.filteredQuestions setArray:self.questions];
	[self.tableView reloadData];
	[self updateFilteredQuestions];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self removeObserver:self forKeyPath:CDStringFromSelector(searchString) context:NULL];
}


#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	if (tableView == self.tableView) {
		rows = self.questions.count;
	} else if (tableView == self.searchDisplayController.searchResultsTableView) {
		rows = self.filteredQuestions.count;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = nil;
	OPFQuestion *question = nil;
	if (tableView == self.tableView) {
		cellIdentifier = QuestionCellIdentifier;
		question = self.questions[indexPath.row];
	} else if (tableView == self.searchDisplayController.searchResultsTableView) {
		cellIdentifier = SearchQuestionsCellIdentifier;
		question = self.filteredQuestions[indexPath.row];
	} else {
		NSAssert(NO, @"Unknown table view %@", tableView);
		return nil;
	}
	
	OPFSingleQuestionPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	[cell configureWithQuestionData:question];
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 150;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	OPFQuestion *question = nil;
	if (tableView == self.tableView) {
		question = self.questions[indexPath.row];
	} else if (tableView == self.searchDisplayController.searchResultsTableView) {
		question = self.filteredQuestions[indexPath.row];
	} else {
		NSAssert(NO, @"Unknown table view %@", tableView);
		return;
	}
	
	OPFQuestionViewController *questionViewController = OPFQuestionViewController.new;
	questionViewController.question = question;
	
	[self.navigationController pushViewController:questionViewController animated:YES];
}


#pragma mark - 
+ (NSRegularExpression *)tagsFromSearchStringRegularExpression
{
	static NSRegularExpression *_tagsRegularExpression = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError *error = NULL;
		_tagsRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\[([^\\[]+)\\]" options:0 error:&error];
		ZAssert(_tagsRegularExpression != nil, @"Could not create regular expression, got the error: %@", error);
	});
	return _tagsRegularExpression;
}

- (NSArray *)tagsFromSearchString:(NSString *)searchString
{
	searchString = searchString.copy;
	NSMutableArray *tags = NSMutableArray.new;
	NSRegularExpression *tagsRegularExpression = self.class.tagsFromSearchStringRegularExpression;
	
	[tagsRegularExpression enumerateMatchesInString:searchString options:0 range:NSMakeRange(0, searchString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		if ([result numberOfRanges] >= 2) {
			NSRange caputerRange = [result rangeAtIndex:1];
			NSString *capture = [searchString substringWithRange:caputerRange];
			[tags addObject:capture.opf_stringByTrimmingWhitespace];
		}
	}];
	
	return tags;
}

- (NSString *)keywordSearchStringFromSearchString:(NSString *)searchString
{
	NSRegularExpression *tagsRegularExpression = self.class.tagsFromSearchStringRegularExpression;
	NSString *keywordSearchString = [tagsRegularExpression stringByReplacingMatchesInString:searchString options:0 range:NSMakeRange(0, searchString.length) withTemplate:@" "];
	return keywordSearchString.opf_stringByTrimmingWhitespace;
}

- (void)updateFilteredQuestions
{
	NSString *searchString = self.searchString;
	NSArray *tags = [self tagsFromSearchString:searchString];
	DLog(@"tags: %@", tags);
	NSString *keywords = [self keywordSearchStringFromSearchString:searchString];
	DLog(@"keywords: %@", keywords);
	
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title LIKE %@ OR body LIKE @%) AND ALL %K IN %@", keywords, keywords, @"tags", tags];
	
	if (keywords.length > 0 || tags.count > 0) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title like[cd] %@", keywords];
		[self.filteredQuestions setArray:[self.questions filteredArrayUsingPredicate:predicate]];
	} else {
		[self.filteredQuestions setArray:self.questions];
	}
	DLog(@"filtered: %@", self.filteredQuestions);
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		[self.searchDisplayController.searchResultsTableView reloadData];
	}];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self && [keyPath isEqualToString:CDStringFromSelector(searchString)]) {
		[self updateFilteredQuestions];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


#pragma mark - UISearchBarDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	self.searchString = searchText;
}


@end
