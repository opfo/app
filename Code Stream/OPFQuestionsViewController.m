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
#import "NSString+OPFStripCharacters.h"


@interface OPFQuestionsViewController (/*Private*/)
#pragma mark - Presented Data
@property (strong) NSMutableArray *filteredQuestions;

#pragma mark - Searching
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end


// It should be possible to search for:
// - Keywords (free text, search in title and body)
// - Tags (match exactly)

@implementation OPFQuestionsViewController {
	BOOL _isFirstTimeAppearing;
}

#pragma mark - Cell Identifiers
static NSString *const QuestionCellIdentifier = @"QuestionCell";


#pragma mark - Object Lifecycle
- (void)sharedQuestionsViewControllerInit
{
	_searchString = @"";
	_isFirstTimeAppearing = YES;
	_filteredQuestions = NSMutableArray.new;
}

- (id)init
{
	self = [super initWithNibName:CDStringFromClass(self) bundle:nil];
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

	self.title = NSLocalizedString(@"Questions", @"Questions view controller title");
	
	self.searchBar.placeholder = NSLocalizedString(@"Search questions and answers…", @"Search questions and answers placeholder text");
	
	[self.tableView registerNib:[UINib nibWithNibName:@"SingleQuestionPreviewCell" bundle:nil] forCellReuseIdentifier:QuestionCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self addObserver:self forKeyPath:CDStringFromSelector(searchString) options:0 context:NULL];
	
	if (self.searchString.length > 0) {
		self.searchBar.text = self.searchString;
	}
	
	// Fetch all questions matching our current search limits.
	// TEMP:
	NSMutableArray *questions = [[[OPFQuestion query] whereColumn:@"tags" like:@"%c#%"] getMany].mutableCopy;
	[questions filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(OPFQuestion* evaluatedObject, NSDictionary *bindings) {
		return evaluatedObject.score.integerValue >= 8;
	}]];
	
	
	[self updateFilteredQuestionsCompletion:^{
		if (_isFirstTimeAppearing) {
			_isFirstTimeAppearing = NO;
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		}
	}];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self removeObserver:self forKeyPath:CDStringFromSelector(searchString) context:NULL];
}

#pragma mark - TabbedViewController methods

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"tab-home";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return NSLocalizedString(@"Questions", @"Questions view controller tab title");
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.filteredQuestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	OPFSingleQuestionPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:QuestionCellIdentifier forIndexPath:indexPath];
	OPFQuestion *question = self.filteredQuestions[indexPath.row];
	[cell configureWithQuestionData:question];
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 150;
}

- (void)setQuestions:(NSArray *)questions {
	NSLog(@"Questions View has recieved %lu questions to insert",(unsigned long)questions.count);
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	OPFQuestion *question = self.filteredQuestions[indexPath.row];
	
	OPFQuestionViewController *questionViewController = OPFQuestionViewController.new;
	questionViewController.question = question;
	
	[self.navigationController pushViewController:questionViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	OPFSingleQuestionPreviewCell *questionCell = (OPFSingleQuestionPreviewCell *)cell;
	questionCell.delegate = self;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	OPFSingleQuestionPreviewCell *questionCell = (OPFSingleQuestionPreviewCell *)cell;
	questionCell.delegate = nil;
}


#pragma mark - GCTagListDelegate Methods
- (void)singleQuestionPreviewCell:(OPFSingleQuestionPreviewCell *)cell didSelectTag:(NSString *)tag
{
	self.searchString = [(self.searchString ?: @"") stringByAppendingFormat:@"[%@]", tag];
	self.searchBar.text = self.searchString;
	
	if (self.tableView.contentOffset.y != 0) {
		[self.tableView setContentOffset:CGPointZero animated:YES];
	}
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
	NSParameterAssert(searchString != nil);
	
	searchString = searchString.copy;
	NSMutableArray *tags = NSMutableArray.new;
	
	// The shortest possible tag is `[a]`, i.e. three (3) chars.
	if (searchString.length >= 3) {
		NSRegularExpression *tagsRegularExpression = self.class.tagsFromSearchStringRegularExpression;
		[tagsRegularExpression enumerateMatchesInString:searchString options:0 range:NSMakeRange(0, searchString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			if ([result numberOfRanges] >= 2) {
				NSRange caputerRange = [result rangeAtIndex:1];
				NSString *capture = [searchString substringWithRange:caputerRange];
				[tags addObject:capture.opf_stringByTrimmingWhitespace];
			}
		}];
	}
	
	return tags;
}

- (NSString *)keywordsSearchStringFromSearchString:(NSString *)searchString
{
	NSParameterAssert(searchString != nil);
	
	NSString *keywordSearchString = @"";
	if (searchString.length > 0) {
		NSRegularExpression *tagsRegularExpression = self.class.tagsFromSearchStringRegularExpression;
		keywordSearchString = [tagsRegularExpression stringByReplacingMatchesInString:searchString options:0 range:NSMakeRange(0, searchString.length) withTemplate:@" "];
		keywordSearchString = keywordSearchString.opf_stringByTrimmingWhitespace;
	}
	
	return keywordSearchString;
}

- (NSPredicate *)questionsFilterPredicateForTags:(NSArray *)tags keywordsString:(NSString *)keywords
{
	NSPredicate *tagsPredicate = [NSPredicate predicateWithBlock:^BOOL(OPFQuestion *evaluatedQuestion, NSDictionary *bindings) {
		__block BOOL shouldInclude = YES;
		[tags enumerateObjectsUsingBlock:^(id aTag, NSUInteger idx, BOOL *stop) {
			shouldInclude = shouldInclude && [evaluatedQuestion.tags containsObject:aTag];
			*stop = !shouldInclude;
		}];
		return shouldInclude;
	}];
	
	NSPredicate *keywordsTitlePredicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@", keywords];
	NSPredicate *keywordsBodyPredicate = [NSPredicate predicateWithFormat:@"body contains[cd] %@", keywords];
	NSPredicate *keywordsPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[ keywordsTitlePredicate, keywordsBodyPredicate ]];
	
	NSPredicate *predicate = nil;
	if (keywords.length > 0 && tags.count > 0) {
		predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ tagsPredicate, keywordsPredicate ]];
	} else if (keywords.length > 0) {
		predicate = keywordsPredicate;
	} else if (tags.count > 0) {
		predicate = tagsPredicate;
	} else {
		ZAssert(NO, @"Well, we’re at that place again. You know that place you really shouldn’t be able to get to. Yeah, we’re there…");
	}
	
	return predicate;
}

- (void)updateFilteredQuestionsCompletion:(void (^)())completionBlock
{
	NSString *searchString = self.searchString ?: @"";
	NSArray *tags = [self tagsFromSearchString:searchString];
	NSString *keywords = [self keywordsSearchStringFromSearchString:searchString];
	
	NSArray *filteredQuestions = nil;
	if (keywords.length > 0 || tags.count > 0) {
		NSPredicate *predicate = [self questionsFilterPredicateForTags:tags keywordsString:keywords];
		filteredQuestions = [[OPFQuestion all:0 per:30] filteredArrayUsingPredicate:predicate];
	} else {
		filteredQuestions = [OPFQuestion all:0 per:30];
	}
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		[self.filteredQuestions setArray:filteredQuestions];
		[self.tableView reloadData];
		if (completionBlock) {
			completionBlock();
		}
	}];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self && [keyPath isEqualToString:CDStringFromSelector(searchString)]) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self updateFilteredQuestionsCompletion:nil];
		});
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


#pragma mark - UISearchBarDelegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:NO animated:YES];
	return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	self.searchString = searchText;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	searchBar.text = @"";
	self.searchString = @"";
}


@end
