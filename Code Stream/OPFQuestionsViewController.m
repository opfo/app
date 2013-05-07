//
//  OPFQuestionsViewController.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionsViewController.h"
#import "OPFTag.h"
#import "OPFUser.h"
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
static NSString *const SuggestedUserCellIdentifier = @"SuggestedUserCellIdentifier";
Boolean heatMode = NO;

#pragma mark - Object Lifecycle
- (void)sharedQuestionsViewControllerInit
{
	_searchString = @"";
	_isFirstTimeAppearing = YES;
	_filteredQuestions = NSMutableArray.new;
	_suggestedTokens = NSMutableArray.new;
}

- (id)init
{
	self = [super initWithNibName:CDStringFromInstance(self) bundle:nil];
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
	self.tableView.rowHeight = 150.f;
	
	self.title = NSLocalizedString(@"Questions", @"Questions view controller title");
	
	OPFQuestionsSearchBarInputView *searchBarInputView = OPFQuestionsSearchBarInputView.new;
	searchBarInputView.completionsView.delegate = self;
	searchBarInputView.completionsView.dataSource = self;
	[searchBarInputView.completionsView registerClass:OPFTagTokenCollectionViewCell.class forCellWithReuseIdentifier:SuggestedTagCellIdentifier];
	[searchBarInputView.completionsView registerClass:OPFUserTokenCollectionViewCell.class forCellWithReuseIdentifier:SuggestedUserCellIdentifier];
	[searchBarInputView.buttonsView.insertNewTagButton addTarget:self action:@selector(insertNewTag:) forControlEvents:UIControlEventTouchUpInside];
	[searchBarInputView.buttonsView.insertNewUserButton addTarget:self action:@selector(insertNewUser:) forControlEvents:UIControlEventTouchUpInside];
	self.searchBarInputView = searchBarInputView;
	
	self.searchBar.inputAccessoryView = searchBarInputView;
	self.searchBar.placeholder = NSLocalizedString(@"Search questions and answers…", @"Search questions and answers placeholder text");
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(askQuestions:)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Heat" style:UIBarButtonItemStylePlain target:self action:@selector(switchHeatMode:)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self addObserver:self forKeyPath:CDStringFromSelector(searchString) options:NSKeyValueObservingOptionOld context:NULL];
	
	if (self.searchString.length > 0) {
		self.searchBar.text = self.searchString;
	}
	
	if (_isFirstTimeAppearing) {
		_isFirstTimeAppearing = NO;
		CGPoint tableViewContentOffset = CGPointMake(0.f, CGRectGetHeight(self.searchBar.frame));
		[self.tableView setContentOffset:tableViewContentOffset animated:NO];
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		[self updateFilteredQuestionsCompletion:nil];
	});
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
    
    //If Heat Mode is turned on, color the cell according to it's score
    [cell heatMode:heatMode];
	
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
	__block NSString *searchString = nil;
	dispatch_sync(dispatch_get_main_queue(), ^{
		searchString = self.searchString.copy ?: @"";
	});
	
	NSArray *tags = [searchString opf_tagsFromSearchString];
	NSArray *users = [searchString opf_usersFromSearchString];
	NSString *keywords = [searchString opf_keywordsSearchStringFromSearchString];
	
	OPFQuery *query = nil;
	if (keywords.length > 0 || tags.count > 0) {
		query = [[[OPFQuestion searchFor:keywords inTags:tags] orderBy:@"score" order:kOPFSortOrderDescending] limit:@(100)];
	} else {
		query = [[[OPFQuestion.query whereColumn:@"score" isGreaterThan:@(8) orEqual:YES] orderBy:@"last_activity_date" order:kOPFSortOrderAscending] limit:@(50)];
	}
	
	NSArray *filteredQuestions = [query getMany];
	
	[NSOperationQueue.mainQueue addOperationWithBlock:^{
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


#pragma mark - Update Suggested Tokens
- (void)updateSuggestedTokensCompletion:(void (^)())completionBlock
{
	__block NSString *tokenBeingInputted = nil;
	dispatch_sync(dispatch_get_main_queue(), ^{
		tokenBeingInputted = self.tokenBeingInputted.copy;
	});
	
	NSArray *suggestedTokens = nil;
	NSInteger queryLimit = 20;
	CGFloat queryLimitWizardOfTheOZFactor = 1;
	OPFQuery *query = nil;
	if (self.tokenBeingInputtedType == kOPFQuestionsViewControllerTokenBeingInputtedTag) {
		NSArray *existingTags = self.searchString.opf_tagsFromSearchString;
		queryLimitWizardOfTheOZFactor = 1.f / (double)(existingTags.count ?: 1.f);
		if (tokenBeingInputted.length == 0) {
			if (existingTags.count > 0) {
				NSMutableOrderedSet *relatedTags = NSMutableOrderedSet.new;
				for (NSString *tag in existingTags) {
					NSArray *relatedTagsSubset = [OPFTag relatedTagsForTagWithName:tag];
					[relatedTags addObjectsFromArray:relatedTagsSubset];
				}
				suggestedTokens = relatedTags.array;
				NSInteger limit = queryLimit * queryLimitWizardOfTheOZFactor;
				NSRange suggestedTokensLimitRange = NSMakeRange(0, relatedTags.count <= limit ? relatedTags.count : limit);
				suggestedTokens = [relatedTags.array subarrayWithRange:suggestedTokensLimitRange];
			} else {
				suggestedTokens = [OPFTag mostCommonTags];
			}
		} else {
            NSString* fuzzyToken = [NSString stringWithFormat:@"%@%%", tokenBeingInputted];
			query = [[OPFTag.query whereColumn:@"name" like: fuzzyToken exact: YES] orderBy:@"name" order:kOPFSortOrderAscending];
		}
	} else if (self.tokenBeingInputtedType == kOPFQuestionsViewControllerTokenBeingInputtedUser) {
		query = [OPFUser.query limit:@(20)];
	} else {
		return;
	}
	
	if (query != nil && suggestedTokens.count == 0) {
		suggestedTokens = [[query limit:@(queryLimit * queryLimitWizardOfTheOZFactor)] getMany];
	}
	
	[NSOperationQueue.mainQueue addOperationWithBlock:^{
		[self.suggestedTokens setArray:suggestedTokens];
		[self.searchBarInputView.completionsView reloadData];
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
			[NSOperationQueue.mainQueue addOperationWithBlock:^{
				[self updateSearchBarWithTokens];
			}];
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[self updateFilteredQuestionsCompletion:nil];
			});
		}
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


#pragma mark - 
- (NSString *)tokenTextFromSuggestedTokenAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *token = nil;
	if (self.tokenBeingInputtedType == kOPFQuestionsViewControllerTokenBeingInputtedTag) {
		OPFTag *tag = self.suggestedTokens[indexPath.row];
		token = tag.name;
	} else if (self.tokenBeingInputtedType == kOPFQuestionsViewControllerTokenBeingInputtedUser) {
		OPFUser *user = self.suggestedTokens[indexPath.row];
		token = user.displayName;
	} else if (self.tokenBeingInputtedType == kOPFQuestionsViewControllerTokenBeingInputtedNone) {
		token = @"";
	} else {
		ZAssert(NO, @"Unkown type of token being inputted, got: %d", self.tokenBeingInputtedType);
	}
	return token;
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
	NSString *cellIdentifier = (self.tokenBeingInputtedType == kOPFQuestionsViewControllerTokenBeingInputtedUser ? SuggestedUserCellIdentifier : SuggestedTagCellIdentifier);
	OPFTokenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	NSString *token = [self tokenTextFromSuggestedTokenAtIndexPath:indexPath];
	cell.tokenView.text = token;
	return cell;
}


#pragma mark - UICollectionViewFlowLayout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *token = [self tokenTextFromSuggestedTokenAtIndexPath:indexPath];
	CGSize tokenSize = [token sizeWithFont:[UIFont systemFontOfSize:kOPFTokenTextFontSize]];
	
	CGFloat width = kOPFTokenPaddingLeft + tokenSize.width + kOPFTokenPaddingRight;
	CGFloat height = kOPFTokenHeight;
	
	CGSize size = CGSizeMake(width, height);
	return size;
}


#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *token = [self tokenTextFromSuggestedTokenAtIndexPath:indexPath];
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
		CGFloat length = ((tokenEndRange.location != NSNotFound && tokenEndRange.location > tokenStartRange.location) ? tokenEndRange.location - location : searchString.length - location);
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
	self.tokenBeingInputted = [NSMutableString stringWithCapacity:20];
	self.tokenBeingInputtedType = type;
	
	NSString *tokenChar = [self tokenCharacterForType:type end:NO];
	[self updateSearchWithString:[self.searchString stringByAppendingString:tokenChar]];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self updateSuggestedTokensCompletion:nil];
	});
	
	[self changeSearchBarInputViewToCompletionsView];
}

- (void)endTokenInput
{
	NSString *token = self.tokenBeingInputted.copy;
	[self replaceCurrentTokenTextWithToken:token];
	
	self.tokenBeingInputted = nil;
	self.tokenBeingInputtedType = kOPFQuestionsViewControllerTokenBeingInputtedNone;
	[self.suggestedTokens removeAllObjects];
	
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
					OPFQuestionsSearchBarToken *token = [OPFQuestionsSearchBarToken tokenWithRange:tokenRange type:tokenType text:tokenContent];
					[tokens addObject:token];
				}
			}
		}];
	}
	
	// Are we possibly in the act of entering a new token?
	if (searchString.length >= 1 && ([searchString hasSuffix:kOPFTokenTagEndCharacter] == NO || [searchString hasSuffix:kOPFTokenUserEndCharacter] == NO)) {
		NSUInteger tagStartCount = [searchString componentsSeparatedByString:kOPFTokenTagStartCharacter].count;
		NSUInteger tagEndCount = [searchString componentsSeparatedByString:kOPFTokenTagEndCharacter].count;
		
		if (tagStartCount != tagEndCount) {
			OPFQuestionsSearchBarToken *token = [self tokenBeingEnteredIntoSearchString:searchString withStartCharacter:kOPFTokenTagStartCharacter type:kOPFQuestionsSearchBarTokenTag];
			[tokens addObject:token];
		} else {
			NSUInteger userStartCount = [searchString componentsSeparatedByString:kOPFTokenUserStartCharacter].count;
//			NSUInteger userEndCount = [searchString componentsSeparatedByString:kOPFTokenUserEndCharacter].count;
			
			if (userStartCount % 2 == 0) {
				OPFQuestionsSearchBarToken *token = [self tokenBeingEnteredIntoSearchString:searchString withStartCharacter:kOPFTokenUserStartCharacter type:kOPFQuestionsSearchBarTokenUser];
				[tokens addObject:token];
			}
		}
	}
	
	self.searchBar.tokens = tokens;
}

- (OPFQuestionsSearchBarToken *)tokenBeingEnteredIntoSearchString:(NSString *)searchString withStartCharacter:(NSString *)startChar type:(OPFQuestionsSearchBarTokenType)type
{
	NSRange rangeOfOpenToken = [searchString rangeOfString:startChar options:NSBackwardsSearch];
	rangeOfOpenToken.length = searchString.length - rangeOfOpenToken.location;
	
	NSRange textRange = NSMakeRange(rangeOfOpenToken.location + 1, searchString.length - (rangeOfOpenToken.location + 1));
	NSString *text = ((textRange.location + textRange.length) <= searchString.length ? [searchString substringWithRange:textRange] : @"");
	
	OPFQuestionsSearchBarToken *token = [OPFQuestionsSearchBarToken tokenWithRange:rangeOfOpenToken type:type text:text];
	
	return token;
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
		self.tokenBeingInputted = nil;
		self.tokenBeingInputtedType = kOPFQuestionsViewControllerTokenBeingInputtedNone;
		[self changeSearchBarInputViewToButtonsView];
	}
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (self.tokenBeingInputted != nil) {
		if (text.length > 0) {
			NSString *tokenEndChar = [self tokenCharacterForType:self.tokenBeingInputtedType end:YES];
			NSRange tokenEndRange = [text rangeOfString:tokenEndChar options:NSBackwardsSearch];
			
			NSUInteger substringIdx = (tokenEndRange.location != NSNotFound ? tokenEndRange.location : text.length);
			NSString *tokenText = [text substringToIndex:substringIdx];
			[self.tokenBeingInputted appendString:tokenText];
		} else if (text.length == 0 && range.length > 0) {
			NSString *replacedText = [self.searchBar.text substringWithRange:range];
			NSString *tokenChar = [self tokenCharacterForType:self.tokenBeingInputtedType end:NO];
			if ([replacedText opf_containsString:tokenChar]) {
				[self.tokenBeingInputted setString:@""];
				[self endTokenInput];
			} else {
				NSUInteger tokenLength = self.tokenBeingInputted.length;
				if (tokenLength > 0) {
					NSRange deleteRange = NSMakeRange(tokenLength - range.length, range.length);
					[self.tokenBeingInputted deleteCharactersInRange:deleteRange];
				}
			}
		}
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self updateSuggestedTokensCompletion:nil];
		});
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
				[self.searchBarInputView.completionsView setContentOffset:CGPointZero animated:NO];
				[self.searchBarInputView.completionsView reloadData];
			}
		}];
	}
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

// Turn on/off heat mode when the "Heat Mode"-button is clicked.
-(void) switchHeatMode:(id) paramSender{
    if(!heatMode){
        heatMode = YES;
        [self.tableView reloadData];
    }
    else{
        heatMode = NO;
        [self.tableView reloadData];
    }
}


@end
