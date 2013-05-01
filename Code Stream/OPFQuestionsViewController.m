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
#import "OPFQuestionsSearchBarInputView.h"
#import "OPFQuestionsSearchBarInputButtonsView.h"
#import "NSString+OPFStripCharacters.h"


@interface OPFQuestionsViewController (/*Private*/)
#pragma mark - Presented Data
@property (strong) NSMutableArray *filteredQuestions;

#pragma mark - Searching
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) OPFQuestionsSearchBarInputView *searchBarInputView;

@end


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
	[self.tableView registerNib:[UINib nibWithNibName:@"SingleQuestionPreviewCell" bundle:nil] forCellReuseIdentifier:QuestionCellIdentifier];
	
	self.title = NSLocalizedString(@"Questions", @"Questions view controller title");
	
	OPFQuestionsSearchBarInputView *searchBarInputView = OPFQuestionsSearchBarInputView.new;
	[searchBarInputView.buttonsView.insertNewTagButton addTarget:self action:@selector(insertNewTag:) forControlEvents:UIControlEventTouchUpInside];
	[searchBarInputView.buttonsView.insertNewUserButton addTarget:self action:@selector(insertNewUser:) forControlEvents:UIControlEventTouchUpInside];
	self.searchBarInputView = searchBarInputView;
	
	self.searchBar.inputAccessoryView = searchBarInputView;
	self.searchBar.placeholder = NSLocalizedString(@"Search questions and answers…", @"Search questions and answers placeholder text");
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self addObserver:self forKeyPath:CDStringFromSelector(searchString) options:NSKeyValueObservingOptionOld context:NULL];
	
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
	self.searchString = [NSString stringWithFormat:@"[%@]", tag ?: @""];
	self.searchBar.text = self.searchString;
	
	if (self.tableView.contentOffset.y != 0) {
		[self.tableView scrollRectToVisible:CGRectZero animated:YES];
	}
}


#pragma mark - 
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
		if ([change[NSKeyValueChangeOldKey] isEqual:self.searchString] == NO) {
			[NSOperationQueue.mainQueue addOperationWithBlock:^{
				self.searchBar.text = self.searchString;
			}];
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[self updateFilteredQuestionsCompletion:nil];
			});
		}
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
	
	if (searchText.length > 0) {
		[searchBar setShowsCancelButton:NO animated:YES];
	} else {
		[searchBar setShowsCancelButton:YES animated:YES];
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	/*
	 if isInputtingTag
		select best match and add it to search
	 else if isInputtingUser
		select best match and add it to search
	 */
	
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	[self changeSearchBarInputViewToButtonsView];
	
	self.searchString = @"";
}


#pragma mark - Search Buttons
// Tag syntax:  [some tag]
// User syntax: @Some cool User@

- (void)insertNewTag:(id)sender
{
	DLog(@"Should insert a new tag at current position.");
	
	[self changeSearchBarInputViewToCompletionsView];
}

- (void)insertNewUser:(id)sender
{
	DLog(@"Should insert a new user at current position.");
	
	[self changeSearchBarInputViewToCompletionsView];
}

- (void)changeSearchBarInputViewToCompletionsView
{
	[self changeSearchBarInputViewToState:kOPFQuestionsSearchBarInputStateCompletions];
}

- (void)changeSearchBarInputViewToButtonsView
{
	[self changeSearchBarInputViewToState:kOPFQuestionsSearchBarInputStateButtons];
}

- (void)changeSearchBarInputViewToState:(OPFQuestionsSearchBarInputState)state
{
	if (self.searchBarInputView.state != state) {
		self.searchBarInputView.state = state;
		[UIView animateWithDuration:.25f animations:^{
			CGFloat searchBarInputWidth = CGRectGetWidth(self.searchBarInputView.frame);
			
			CGRect buttonsFrame = self.searchBarInputView.buttonsView.frame;
			buttonsFrame.origin.x = (state == kOPFQuestionsSearchBarInputStateButtons ? 0.f : -searchBarInputWidth);
			self.searchBarInputView.buttonsView.frame = buttonsFrame;
			
			CGRect completionsFrame = self.searchBarInputView.completionsView.frame;
			completionsFrame.origin.x = (state == kOPFQuestionsSearchBarInputStateCompletions ? 0.f : searchBarInputWidth);
			self.searchBarInputView.completionsView.frame = completionsFrame;
		}];
	}
}


#pragma mark - Getting Tags, Users and Keywords From Search Input
- (NSArray *)tagsFromSearchString:(NSString *)searchString
{
	NSParameterAssert(searchString != nil);
	
	NSRegularExpression *regularExpression = self.class.tagsFromSearchStringRegularExpression;
	NSArray *tags = [self tokensFromSearchString:searchString tokenRegularExpression:regularExpression];
	return tags;
}

- (NSArray *)usersFromSearchString:(NSString *)searchString
{
	NSParameterAssert(searchString != nil);
	
	NSRegularExpression *regularExpression = self.class.usersFromSearchStringRegularExpression;
	NSArray *users = [self tokensFromSearchString:searchString tokenRegularExpression:regularExpression];
	return users;
}

- (NSArray *)tokensFromSearchString:(NSString *)searchString tokenRegularExpression:(NSRegularExpression *)regularExpression
{
	NSParameterAssert(searchString != nil);
	NSParameterAssert(regularExpression != nil);
	
	searchString = searchString.copy;
	NSMutableArray *tokens = NSMutableArray.new;
	
	// The shortest possible tag is `[a]`, i.e. three (3) chars.
	if (searchString.length >= 3) {
		[regularExpression enumerateMatchesInString:searchString options:0 range:NSMakeRange(0, searchString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			if ([result numberOfRanges] >= 2) {
				NSRange caputerRange = [result rangeAtIndex:1];
				NSString *capture = [searchString substringWithRange:caputerRange];
				[tokens addObject:capture.opf_stringByTrimmingWhitespace];
			}
		}];
	}
	
	return tokens;
}

- (NSString *)keywordsSearchStringFromSearchString:(NSString *)searchString
{
	NSParameterAssert(searchString != nil);
	
	NSString *keywordSearchString = @"";
	if (searchString.length > 0) {
		NSRegularExpression *replacementRgularExpression = self.class.nonKeywordsFromSearchStringRegularExpression;
		keywordSearchString = [replacementRgularExpression stringByReplacingMatchesInString:searchString options:0 range:NSMakeRange(0, searchString.length) withTemplate:@" "];
		
		keywordSearchString = keywordSearchString.opf_stringByTrimmingWhitespace;
	}
	
	return keywordSearchString;
}

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

+ (NSRegularExpression *)usersFromSearchStringRegularExpression
{
	static NSRegularExpression *_usersRegularExpression = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError *error = NULL;
		_usersRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"@([^@]+)@" options:0 error:&error];
		ZAssert(_usersRegularExpression != nil, @"Could not create regular expression, got the error: %@", error);
	});
	return _usersRegularExpression;
}

+ (NSRegularExpression *)nonKeywordsFromSearchStringRegularExpression
{
	static NSRegularExpression *_nonKeywordsRegularExpression = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSError *error = NULL;
		_nonKeywordsRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"@([^@]+)@|\\[([^\\[]+)\\]" options:0 error:&error];
		ZAssert(_nonKeywordsRegularExpression != nil, @"Could not create regular expression, got the error: %@", error);
	});
	return _nonKeywordsRegularExpression;
}


#pragma mark - Questions Filter
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


@end
