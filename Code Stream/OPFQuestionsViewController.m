//
//  OPFQuestionsViewController.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsViewController.h"
#import "OPFQuestion.h"
#import "OPFQuestionViewController.h"
#import "OPFSingleQuestionPreviewCell.h"
#import "OPFQuestionsSearchBar.h"
#import "OPFQuestionsSearchBarInputView.h"
#import "OPFQuestionsSearchBarInputButtonsView.h"
#import "OPFQuestionsSearchBarTokenView.h"
#import "OPFQuestionsSearchBarTokenRange.h"
#import "OPFTokenCollectionViewCell.h"
#import "NSString+OPFStripCharacters.h"


typedef enum : NSInteger {
	kOPFQuestionsViewControllerTokenBeingInputtedNone,
	kOPFQuestionsViewControllerTokenBeingInputtedTag,
	kOPFQuestionsViewControllerTokenBeingInputtedUser
} OPFQuestionsViewControllerTokenBeingInputtedType;

// Tag syntax:  [some tag]
NSString *const kOPFQuestionsViewControllerTagTokenStartCharacter = @"[";
NSString *const kOPFQuestionsViewControllerTagTokenEndCharacter = @"]";

// User syntax: @Some cool User@
NSString *const kOPFQuestionsViewControllerUserTokenStartCharacter = @"@";
NSString *const kOPFQuestionsViewControllerUserTokenEndCharacter = @"@";


@interface OPFQuestionsViewController (/*Private*/)
#pragma mark - Presented Data
@property (strong) NSMutableArray *filteredQuestions;

#pragma mark - Searching
@property (weak, nonatomic) IBOutlet OPFQuestionsSearchBar *searchBar;
@property (strong, nonatomic) OPFQuestionsSearchBarInputView *searchBarInputView;

@property (assign) OPFQuestionsViewControllerTokenBeingInputtedType tokenBeingInputtedType;
@property (strong) NSMutableString *tokenBeingInputted;
@property (strong) NSMutableArray *suggestedTokens;

@end


@implementation OPFQuestionsViewController {
	BOOL _isFirstTimeAppearing;
}

#pragma mark - Cell Identifiers
static NSString *const QuestionCellIdentifier = @"QuestionCell";
static NSString *const SuggestedTagCellIdentifier = @"SuggestedTagCellIdentifier";

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
	self.suggestedTokens = @[ @"java", @"javafx", @"javascript", @"jaq", @"outside", @"even further outside" ].mutableCopy;
	
	[super viewDidLoad];
	[self.tableView registerNib:[UINib nibWithNibName:@"SingleQuestionPreviewCell" bundle:nil] forCellReuseIdentifier:QuestionCellIdentifier];
	
	self.title = NSLocalizedString(@"Questions", @"Questions view controller title");
	
	OPFQuestionsSearchBarInputView *searchBarInputView = OPFQuestionsSearchBarInputView.new;
	searchBarInputView.completionsView.delegate = self;
	searchBarInputView.completionsView.dataSource = self;
	[searchBarInputView.completionsView registerClass:OPFTokenCollectionViewCell.class forCellWithReuseIdentifier:SuggestedTagCellIdentifier];
	[searchBarInputView.buttonsView.insertNewTagButton addTarget:self action:@selector(insertNewTag:) forControlEvents:UIControlEventTouchUpInside];
	[searchBarInputView.buttonsView.insertNewUserButton addTarget:self action:@selector(insertNewUser:) forControlEvents:UIControlEventTouchUpInside];
	self.searchBarInputView = searchBarInputView;
	
	self.searchBar.inputAccessoryView = searchBarInputView;
	self.searchBar.placeholder = NSLocalizedString(@"Search questions and answers…", @"Search questions and answers placeholder text");
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(askQuestions:)];
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
	[self dismissSearchBarExtras];
	
	OPFQuestionViewController *questionViewController = OPFQuestionViewController.new;
	OPFQuestion *question = self.filteredQuestions[indexPath.row];
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


#pragma mark - Update Filtered Questions
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


#pragma mark - Key Value Obseravation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self && [keyPath isEqualToString:CDStringFromSelector(searchString)]) {
		if ([change[NSKeyValueChangeOldKey] isEqual:self.searchString] == NO) {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[self updateFilteredQuestionsCompletion:nil];
			});
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


#pragma mark - Asking New Questions
- (IBAction)askQuestions:(id)sender
{
	DLog(@"Asking new questions has not been implemtend.");
	
	UIViewController *askQuestionsViewController = UIViewController.new;
	askQuestionsViewController.view.backgroundColor = UIColor.redColor;
	
	UINavigationController *askQuestionsNavigationController = [[UINavigationController alloc] initWithRootViewController:askQuestionsViewController];
	
	__weak typeof(self) weakSelf = self;
	[self presentViewController:askQuestionsNavigationController animated:YES completion:^{
		double delayInSeconds = .5f;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			UIViewController *self = weakSelf;
			[self dismissViewControllerAnimated:YES completion:nil];
		});
	}];
}


#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.suggestedTokens.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	OPFTokenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SuggestedTagCellIdentifier forIndexPath:indexPath];
	cell.tokenView.text = self.suggestedTokens[indexPath.row];
	return cell;
}


#pragma mark - UICollectionViewFlowLayout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = kOPFTokenHeight;
	
	NSString *token = self.suggestedTokens[indexPath.row];
	CGSize tokenSize = [token sizeWithFont:[UIFont systemFontOfSize:kOPFTokenTextFontSize]];
	CGFloat width = kOPFTokenPaddingLeft + tokenSize.width + kOPFTokenPaddingRight;
	
	CGSize size = CGSizeMake(width, height);
	return size;
}


#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	DLog(@"%@", self.suggestedTokens[indexPath.row]);
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
	
	if (searchText.length == 0) {
		[self changeSearchBarInputViewToButtonsView];
	}
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	NSString *changedText = [searchBar.text substringWithRange:range];
	DLog(@"changeText: %@", changedText);
	DLog(@"text: %@", text);
	
	if ([changedText rangeOfString:kOPFQuestionsViewControllerTagTokenStartCharacter].location != NSNotFound) {
		[self changeSearchBarInputViewToButtonsView];
	}
	
	if (([text rangeOfString:kOPFQuestionsViewControllerTagTokenStartCharacter].location != NSNotFound ||
		[text rangeOfString:kOPFQuestionsViewControllerUserTokenStartCharacter].location != NSNotFound) &&
		self.tokenBeingInputted == nil) {
		self.tokenBeingInputted = NSMutableString.new;
		
		[self changeSearchBarInputViewToCompletionsView];
	}
	
	if (([text rangeOfString:kOPFQuestionsViewControllerTagTokenEndCharacter].location != NSNotFound ||
		 [text rangeOfString:kOPFQuestionsViewControllerUserTokenEndCharacter].location != NSNotFound) &&
		self.tokenBeingInputted != nil) {
		// THEN: A tag or user was added
		self.tokenBeingInputted = nil;
		self.tokenBeingInputtedType = kOPFQuestionsViewControllerTokenBeingInputtedNone;
		[self changeSearchBarInputViewToButtonsView];
	} else if (self.tokenBeingInputted != nil) {
		DLog(@"add to token %@", text);
		[self.tokenBeingInputted appendString:text];
	}
	
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	/*
	 if isInputtingTag
		select best match and add it to search
	 else if isInputtingUser
		select best match and add it to search
	 */
	
	[self dismissSearchBarExtras];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self dismissSearchBarExtras];
	[self changeSearchBarInputViewToButtonsView];
	
	self.searchString = @"";
	self.searchBar.text = @"";
}

- (void)dismissSearchBarExtras
{
	[self.searchBar resignFirstResponder];
}


#pragma mark - Search Buttons
- (IBAction)insertNewTag:(id)sender
{
	[self changeSearchBarInputViewToCompletionsView];
//	self.tokenBeingInputtedType = kOPFQuestionsViewControllerTokenBeingInputtedTag;
//	self.tokenBeingInputted = NSMutableString.new;
//	
//	NSRange range = NSMakeRange(<#NSUInteger loc#>, <#NSUInteger len#>);
//	OPFQuestionsSearchBarTokenRange *tokenRange = [OPFQuestionsSearchBarTokenRange tokenRangeWithRange:range];
//	[self.searchBar.tagRanges ]
	
	self.searchString = [self.searchString stringByAppendingString:kOPFQuestionsViewControllerTagTokenStartCharacter];
	self.searchBar.text = self.searchString;
}

- (IBAction)insertNewUser:(id)sender
{
	[self changeSearchBarInputViewToCompletionsView];
	
	self.searchString = [self.searchString stringByAppendingString:kOPFQuestionsViewControllerUserTokenStartCharacter];
	self.searchBar.text = self.searchString;
	DLog(@"Should insert a new user at current position.");
}

- (IBAction)endCurrentToken:(id)sender
{
	NSString *endChar = nil;
	switch (self.tokenBeingInputtedType) {
		case kOPFQuestionsViewControllerTokenBeingInputtedNone: /*NOP*/ break;
		case kOPFQuestionsViewControllerTokenBeingInputtedTag: endChar = kOPFQuestionsViewControllerTagTokenEndCharacter; break;
		case kOPFQuestionsViewControllerTokenBeingInputtedUser: endChar = kOPFQuestionsViewControllerUserTokenEndCharacter; break;
		
		default: ZAssert(NO, @"Unknown type for token being inputted, got %d.", self.tokenBeingInputtedType); break;
	}
	
	if (endChar) {
		self.searchString = [self.searchString stringByAppendingString:endChar];
		self.searchBar.text = self.searchString;
	}
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
		} completion:^(BOOL finished) {
			if (finished && state == kOPFQuestionsSearchBarInputStateCompletions) {
				[self.searchBarInputView.completionsView reloadData];
			}
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


#pragma mark - TabbedViewController methods
- (NSString *)tabImageName
{
    return @"tab-home";
}

- (NSString *)tabTitle
{
    return NSLocalizedString(@"Questions", @"Questions view controller tab title");
}


@end
