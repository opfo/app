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
#import "OPFTokenCollectionViewCell.h"
#import "NSRegularExpression+OPFSearchString.h"
#import "NSString+OPFContains.h"
#import "NSString+OPFSearchString.h"
#import "NSString+OPFStripCharacters.h"


typedef enum : NSInteger {
	kOPFQuestionsViewControllerTokenBeingInputtedNone = kOPFQuestionsSearchBarTokenCustom,
	kOPFQuestionsViewControllerTokenBeingInputtedTag = kOPFQuestionsSearchBarTokenTag,
	kOPFQuestionsViewControllerTokenBeingInputtedUser = kOPFQuestionsSearchBarTokenUser
} OPFQuestionsViewControllerTokenBeingInputtedType;


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
	NSParameterAssert(tag.length > 0);
	
	[self updateSearchWithString:tag.opf_stringAsTagTokenString];
	
	if (self.tableView.contentOffset.y != 0) {
		[self.tableView scrollRectToVisible:CGRectZero animated:YES];
	}
}


#pragma mark - Update Filtered Questions
- (void)updateFilteredQuestionsCompletion:(void (^)())completionBlock
{
	NSString *searchString = self.searchString ?: @"";
	NSArray *tags = [searchString opf_tagsFromSearchString];
	NSArray *users = [searchString opf_usersFromSearchString];
	NSString *keywords = [searchString opf_keywordsSearchStringFromSearchString];
	
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

- (void)updateSearchWithString:(NSString *)searchString
{
	self.searchString = searchString;
	self.searchBar.text = self.searchString;
}


#pragma mark - Key Value Obseravation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self && [keyPath isEqualToString:CDStringFromSelector(searchString)]) {
		if ([change[NSKeyValueChangeOldKey] isEqual:self.searchString] == NO) {
			[NSOperationQueue.mainQueue addOperationWithBlock:^{
				[self updateSearchBarWithTokens];
			}];
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
	NSString *token = self.suggestedTokens[indexPath.row];
	[self didSelectToken:token];
}


#pragma mark - Token Handling
- (void)didSelectToken:(NSString *)token
{
	[self.tokenBeingInputted setString:token];
	[self endTokenInput];
}

- (void)replaceCurrentTokenTextWithToken:(NSString *)token
{
	NSMutableString *searchString = self.searchString.mutableCopy;
	NSString *tokenStartChar = [self tokenCharacterForType:self.tokenBeingInputtedType end:NO];
	NSString *tokenEndChar = [self tokenCharacterForType:self.tokenBeingInputtedType end:YES];
	NSRange tokenStartRange = [searchString rangeOfString:tokenStartChar options:NSBackwardsSearch];
	NSRange tokenEndRange = [searchString rangeOfString:tokenEndChar options:NSBackwardsSearch];
	
	if (tokenStartRange.location != NSNotFound) {
		CGFloat location = tokenStartRange.location + tokenStartRange.length;
		CGFloat length = (tokenEndRange.location != NSNotFound ? tokenEndRange.location - location : searchString.length - location);
		NSRange replacementRange = NSMakeRange(location, length);
		
		if (replacementRange.location < searchString.length) {
			[searchString deleteCharactersInRange:replacementRange];
		}
		[searchString insertString:token atIndex:location];
		
		if (tokenEndRange.location == NSNotFound || tokenEndRange.location <= tokenStartRange.location) {
			[searchString appendString:tokenEndChar];
		}
		
		[self updateSearchWithString:searchString.copy];
	}
}

- (void)startTokenInputOfType:(OPFQuestionsViewControllerTokenBeingInputtedType)type
{
	self.tokenBeingInputted = NSMutableString.new;
	self.tokenBeingInputtedType = type;
	
	NSString *tokenChar = [self tokenCharacterForType:type end:NO];
	[self updateSearchWithString:[self.searchString stringByAppendingString:tokenChar]];
	
	[self changeSearchBarInputViewToCompletionsView];
}

- (void)endTokenInput
{
	NSString *token = self.tokenBeingInputted.copy;
	[self replaceCurrentTokenTextWithToken:token];
	
	self.tokenBeingInputted = nil;
	self.tokenBeingInputtedType = kOPFQuestionsViewControllerTokenBeingInputtedNone;
	
	[self changeSearchBarInputViewToButtonsView];
}

- (NSString *)tokenCharacterForType:(OPFQuestionsViewControllerTokenBeingInputtedType)type end:(BOOL)end
{
	NSString *tokenChar = nil;
	switch (type) {
		case kOPFQuestionsViewControllerTokenBeingInputtedNone: tokenChar = @""; break;
		case kOPFQuestionsViewControllerTokenBeingInputtedTag: tokenChar =  (end == NO ? kOPFTokenTagStartCharacter : kOPFTokenTagEndCharacter); break;
		case kOPFQuestionsViewControllerTokenBeingInputtedUser: tokenChar =  (end == NO ? kOPFTokenUserStartCharacter : kOPFTokenUserEndCharacter); break;
		default: ZAssert(NO, @"Unknown token type %d", type); break;
	}
	return tokenChar;
}

- (void)updateSearchBarWithTokens
{
	// 1. Get all complete tokens (tags and users) and their location
	// 2. Get any incomplete token at the end of the string
	
	NSMutableArray *tokens = NSMutableArray.new;
	
	// 3 is the shortest possible tag.
	NSString *searchString = self.searchString;
	if (searchString.length >= 3) {
		NSRegularExpression *tokensRegex = NSRegularExpression.opf_nonKeywordsFromSearchStringRegularExpression;
		[tokensRegex enumerateMatchesInString:searchString options:0 range:NSMakeRange(0, searchString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			if (result.numberOfRanges > 0) {
				NSRange tokenRange = [result rangeAtIndex:0];
				OPFQuestionsSearchBarTokenType tokenType = kOPFQuestionsSearchBarTokenCustom;
				if ([searchString rangeOfString:kOPFTokenTagStartCharacter options:NSAnchoredSearch range:tokenRange].location != NSNotFound) {
					tokenType = kOPFQuestionsSearchBarTokenTag;
				} else if ([searchString rangeOfString:kOPFTokenUserStartCharacter options:NSAnchoredSearch range:tokenRange].location != NSNotFound) {
					tokenType = kOPFQuestionsSearchBarTokenUser;
				}
				
				NSRange contentRange = NSMakeRange(tokenRange.location + 1, tokenRange.length - 2);
				NSString *tokenContent = [searchString substringWithRange:contentRange];
				tokenContent = tokenContent.opf_stringByTrimmingWhitespace;
				
				if (tokenContent.length > 0) {
					OPFQuestionsSearchBarToken *token = [OPFQuestionsSearchBarToken tokenWithRange:tokenRange type:tokenType];
					[tokens addObject:token];
				}
			}
		}];
	}
	
	DLog(@"tokens before: %@", tokens);
	
	// Are we possibly in the act of entering a new token?
	if (searchString.length >= 1 && ([searchString hasSuffix:kOPFTokenTagEndCharacter] == NO || [searchString hasSuffix:kOPFTokenUserEndCharacter] == NO)) {
		NSUInteger tagStartCount = [searchString componentsSeparatedByString:kOPFTokenTagStartCharacter].count;
		NSUInteger tagEndCount = [searchString componentsSeparatedByString:kOPFTokenTagEndCharacter].count;
		
		if (tagStartCount != tagEndCount) {
			NSRange rangeOfOpenToken = [searchString rangeOfString:kOPFTokenTagStartCharacter options:NSBackwardsSearch];
			rangeOfOpenToken.length = searchString.length - rangeOfOpenToken.location;
			OPFQuestionsSearchBarToken *token = [OPFQuestionsSearchBarToken tokenWithRange:rangeOfOpenToken type:kOPFQuestionsSearchBarTokenTag];
			[tokens addObject:token];
		} else {
			NSUInteger userStartCount = [searchString componentsSeparatedByString:kOPFTokenUserStartCharacter].count;
//			NSUInteger userEndCount = [searchString componentsSeparatedByString:kOPFTokenUserEndCharacter].count;
			
			if (userStartCount % 2 == 0) {
				NSRange rangeOfOpenToken = [searchString rangeOfString:kOPFTokenUserStartCharacter options:NSBackwardsSearch];
				rangeOfOpenToken.length = searchString.length - rangeOfOpenToken.location;
				OPFQuestionsSearchBarToken *token = [OPFQuestionsSearchBarToken tokenWithRange:rangeOfOpenToken type:kOPFQuestionsSearchBarTokenUser];
				[tokens addObject:token];
			}
		}
	}
	DLog(@"tokens after: %@", tokens);
	self.searchBar.tokens = tokens;
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
	if (self.tokenBeingInputted != nil && text.length > 0) {
		NSString *tokenEndChar = [self tokenCharacterForType:self.tokenBeingInputtedType end:YES];
		NSRange tokenEndRange = [text rangeOfString:tokenEndChar options:NSBackwardsSearch];
		
		NSUInteger substringIdx = (tokenEndRange.location != NSNotFound ? tokenEndRange.location : text.length);
		NSString *tokenText = [text substringToIndex:substringIdx];
		[self.tokenBeingInputted appendString:tokenText];
	}
	
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	if ((self.tokenBeingInputtedType == kOPFQuestionsSearchBarTokenStyleTag ||
		 self.tokenBeingInputtedType == kOPFQuestionsSearchBarTokenStyleUser) &&
		self.suggestedTokens.count > 0) {
		NSString *token = self.suggestedTokens[0];
		[self didSelectToken:token];
	}
	
	[self dismissSearchBarExtras];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self dismissSearchBarExtras];
	[self changeSearchBarInputViewToButtonsView];
	[self updateSearchWithString:@""];
}

- (void)dismissSearchBarExtras
{
	[self.searchBar resignFirstResponder];
}


#pragma mark - Search Input Accessory Buttons
- (IBAction)insertNewTag:(id)sender
{
	[self startTokenInputOfType:kOPFQuestionsViewControllerTokenBeingInputtedTag];
}

- (IBAction)insertNewUser:(id)sender
{
	[self startTokenInputOfType:kOPFQuestionsViewControllerTokenBeingInputtedUser];
}


#pragma mark - Changing Search Input Accessory View
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
