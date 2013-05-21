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

#import "OPFPostQuestionViewController.h"
#import "OPFAppState.h"
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
#import "OPFSearchBarHeader.h"
#import "UIView+OPFViewLoading.h"
#import "UIScrollView+OPFScrollDirection.h"
#import "UIColor+OPFAppColors.h"

#import <BlocksKit.h>


typedef enum : NSInteger {
	kOPFQuestionsViewControllerTokenBeingInputtedNone = kOPFQuestionsSearchBarTokenCustom,
	kOPFQuestionsViewControllerTokenBeingInputtedTag = kOPFQuestionsSearchBarTokenTag,
	kOPFQuestionsViewControllerTokenBeingInputtedUser = kOPFQuestionsSearchBarTokenUser
} OPFQuestionsViewControllerTokenBeingInputtedType;


typedef enum ScrollDirection : NSInteger {
    kOPFQuestionsViewControllerScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;


@interface OPFQuestionsViewController (/*Private*/)
#pragma mark - Presented Data
@property (strong) NSMutableArray *filteredQuestions;

#pragma mark - Searching
@property (readonly, nonatomic) OPFQuestionsSearchBar *searchBar;
@property (strong) OPFSearchBarHeader *searchBarHeader;
@property (strong, nonatomic) OPFQuestionsSearchBarInputView *searchBarInputView;

@property (assign) OPFQuestionsViewControllerTokenBeingInputtedType tokenBeingInputtedType;
@property (strong) NSMutableString *tokenBeingInputted;
@property (strong) NSMutableArray *suggestedTokens;

#pragma mark - Sorting
@property (strong) NSString *sortCriterion;
@property OPFSortOrder sortOrder;

#pragma mark - Scrolling
@property (assign, nonatomic) CGFloat lastContentOffset;

@end


@implementation OPFQuestionsViewController {
	BOOL _isFirstTimeAppearing;
}

#pragma mark - Cell Identifiers
static NSString *const QuestionCellIdentifier = @"QuestionCell";
static NSString *const SuggestedTagCellIdentifier = @"SuggestedTagCellIdentifier";
static NSString *const SuggestedUserCellIdentifier = @"SuggestedUserCellIdentifier";


#pragma mark - Object Lifecycle
- (void)sharedQuestionsViewControllerInit
{
	_searchString = @"";
	_isFirstTimeAppearing = YES;
	_sortCriterion = @"last_activity_date";
	_sortOrder = kOPFSortOrderDescending;
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
	self.tableView.rowHeight = 74.f;
	
	self.searchBarHeader = [OPFSearchBarHeader opf_loadViewFromNIB];
	self.searchBarHeader.delegate = self;
	[self.searchBarHeader.sortOrderControl addTarget:self action:@selector(updateSorting:) forControlEvents:UIControlEventValueChanged];
	self.tableView.tableHeaderView = self.searchBarHeader;
	
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
	self.searchBar.delegate = self;
    
    UIBarButtonItem *writeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(askQuestions:)];
	self.navigationItem.rightBarButtonItem = writeButton;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    // If user is logged out, disable button, otherwise enable it
    self.navigationItem.rightBarButtonItem.enabled = OPFAppState.sharedAppState.isLoggedIn;
    
	[self.searchBarHeader setDisplayedHeader:kOPFSearchBar WithAnimation:NO];
	
	[self addObserver:self forKeyPath:CDStringFromSelector(searchString) options:NSKeyValueObservingOptionOld context:NULL];
	[self addObserver:self forKeyPath:CDStringFromSelector(sortCriterion) options:NSKeyValueObservingOptionOld context:NULL];
	[self addObserver:self forKeyPath:CDStringFromSelector(sortOrder) options:NSKeyValueObservingOptionOld context:NULL];
	
	if (self.searchString.length > 0) {
		self.searchBar.text = self.searchString;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		[self updateFilteredQuestionsCompletion:nil];
	});
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	

	if (_isFirstTimeAppearing) {
		_isFirstTimeAppearing = NO;
		CGPoint tableViewContentOffset = CGPointMake(0.f, CGRectGetHeight(self.tableView.tableHeaderView.frame));
		[self.tableView setContentOffset:tableViewContentOffset animated:NO];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
	[self removeObserver:self forKeyPath:CDStringFromSelector(searchString) context:NULL];
	[self removeObserver:self forKeyPath:CDStringFromSelector(sortCriterion) context:NULL];
	[self removeObserver:self forKeyPath:CDStringFromSelector(sortOrder) context:NULL];
}


#pragma mark - Presenting View Controllers
- (void)presentViewControllerForQuestion:(OPFQuestion *)question animated:(BOOL)animated
{
	NSParameterAssert(question != nil);
	
	OPFQuestionViewController *questionViewController = OPFQuestionViewController.new;
	questionViewController.question = question;
	
	[self.navigationController pushViewController:questionViewController animated:animated];
}

- (void)presentAskQuestionViewControllerAnimated:(BOOL)animated
{
	OPFPostQuestionViewController *postQuestionViewController = OPFPostQuestionViewController.new;
    postQuestionViewController.title = @"Post a question";
	
    UINavigationController *postQuestionNavigationController = [[UINavigationController alloc] initWithRootViewController:postQuestionViewController];
	postQuestionNavigationController.view.backgroundColor = UIColor.opf_defaultBackgroundColor;
	
	postQuestionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(__unused id _) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}];
	postQuestionViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(__unused  id _) {
       
        OPFQuestion *newQuestion = postQuestionViewController.postButtonPressed;
		
		
        if(newQuestion!=nil){
            [self dismissViewControllerAnimated:YES completion:^{
                if (newQuestion != nil) {
                    [self presentViewControllerForQuestion:newQuestion animated:YES];
                }
            }];
		}
	}];
	
	[self presentViewController:postQuestionNavigationController animated:animated completion:nil];
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
	return 74.f;
}


#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self dismissSearchBarExtras];
	
	OPFQuestion *question = self.filteredQuestions[indexPath.row];
	[self presentViewControllerForQuestion:question animated:YES];
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
// Must NOT be called from the main thread/queue. I.e. call it from a background
// thread.
- (void)updateFilteredQuestionsCompletion:(void (^)())completionBlock
{
	__block NSString *searchString = nil;
	dispatch_sync(dispatch_get_main_queue(), ^{
		searchString = self.searchString.copy ?: @"";
	});
		
		
	OPFQuery *query = self.query;
	if (searchString.length > 0) {
		NSArray *tags = [searchString opf_tagsFromSearchString];
		NSArray *users = [searchString opf_usersFromSearchString];
		NSString *keywords = [searchString opf_keywordsSearchStringFromSearchString];
		NSString *usersAsString = [users componentsJoinedByString:@" "];
		keywords = [keywords stringByAppendingString:usersAsString];
		
		if (keywords.length > 0 || tags.count > 0) {
			NSArray *tagNames = [tags map:^(OPFTag *tag) { return tag.name; }];
			query = [[OPFQuestion searchFor:keywords inTags:tagNames] orderBy:self.sortCriterion order:self.sortOrder];
		}
	}
	
	query = query ?: [OPFQuestion.hotQuestionsQuery orderBy:self.sortCriterion order:self.sortOrder];
	NSArray *filteredQuestions = [[query limit:@(100)] getMany];
	
	[NSOperationQueue.mainQueue addOperationWithBlock:^{
		[self.filteredQuestions setArray:filteredQuestions];
		[self.tableView reloadData];
		CDExecutePossibleBlock(completionBlock);
	}];
}

- (void)updateSearchWithString:(NSString *)searchString
{
	self.searchString = searchString;
	self.searchBar.text = self.searchString;
}

- (IBAction)updateSorting:(UISegmentedControl *) sender {
	switch ((kOPFSortOrder)sender.selectedSegmentIndex) {
		case kOPFScore:
			self.sortCriterion = @"score";
			break;
		case kOPFActivity:
			self.sortCriterion = @"last_activity_date";
			break;
		case kOPFCreated:
			self.sortCriterion = @"creation_date";
			break;
		default:
			@throw @"Undefined sort Order. Please enhance the enum sortOrder and add segment in segmented Control";
			break;
	}
	
	self.sortOrder = kOPFSortOrderDescending;
}


#pragma mark - Update Suggested Tokens
// Must NOT be called from the main thread/queue. I.e. call it from a background
// thread.
- (void)updateSuggestedTokensCompletion:(void (^)())completionBlock
{
	__block NSString *tokenBeingInputted = nil;
	dispatch_sync(dispatch_get_main_queue(), ^{
		tokenBeingInputted = self.tokenBeingInputted.copy;
	});
	
	NSArray *suggestedTokens = nil;
	NSUInteger queryLimit = 20;
	CGFloat queryLimitWizardOfTheOZFactor = 1;
	OPFQuery *query = nil;
	if (self.tokenBeingInputtedType == kOPFQuestionsViewControllerTokenBeingInputtedTag) {
		NSArray *existingTags = self.searchString.opf_tagsFromSearchString;
		queryLimitWizardOfTheOZFactor = 1.f / (CGFloat)(existingTags.count ?: 1.f);
		if (tokenBeingInputted.length > 0) {
			NSString* fuzzyToken = [NSString stringWithFormat:@"%@%%", tokenBeingInputted];
			query = [[OPFTag.query whereColumn:@"name" like: fuzzyToken exact: YES] orderBy:@"name" order:kOPFSortOrderAscending];
		} else if (existingTags.count > 0) {
			NSMutableOrderedSet *relatedTags = NSMutableOrderedSet.new;
			[existingTags each:^(OPFTag *tag) {
				[relatedTags addObjectsFromArray:tag.relatedTags];
			}];
			[relatedTags removeObjectsInArray:existingTags];
			
			NSUInteger limit = (NSUInteger)((CGFloat)queryLimit * queryLimitWizardOfTheOZFactor);
			NSRange suggestedTokensLimitRange = NSMakeRange(0, relatedTags.count <= limit ? relatedTags.count : limit);
			suggestedTokens = [relatedTags.array subarrayWithRange:suggestedTokensLimitRange];
		} else {
			suggestedTokens = [OPFTag mostCommonTags];
		}
	} else if (self.tokenBeingInputtedType == kOPFQuestionsViewControllerTokenBeingInputtedUser) {
		query = OPFUser.query;
		if (tokenBeingInputted.length > 0) {
			NSString *fuzzyToken = [NSString stringWithFormat:@"%@%%", tokenBeingInputted];
			query = [[query whereColumn:@"display_name" like:fuzzyToken exact:YES] orderBy:@"display_name" order:kOPFSortOrderAscending];
		} else {
			query = [query orderBy:@"reputation" order:kOPFSortOrderDescending];
		}
	} else {
		return;
	}
	
	if (query != nil && suggestedTokens.count == 0) {
		suggestedTokens = [[query limit:@(queryLimit * queryLimitWizardOfTheOZFactor)] getMany];
	}
	
	[NSOperationQueue.mainQueue addOperationWithBlock:^{
		[self.suggestedTokens setArray:suggestedTokens];
		[self.searchBarInputView.completionsView reloadData];
		CDExecutePossibleBlock(completionBlock);
	}];
}


#pragma mark - Key Value Observation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self &&
		([keyPath isEqualToString:CDStringFromSelector(searchString)] ||
		 [keyPath isEqualToString:CDStringFromSelector(sortCriterion)] ||
		 [keyPath isEqualToString:CDStringFromSelector(sortOrder)])) {
		if ([change[NSKeyValueChangeOldKey] isEqual:self.searchString] == YES)
			return;
		else {
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
	[self presentAskQuestionViewControllerAnimated:YES];
}


#pragma mark - Token Text From Suggested Token
- (NSString *)tokenTextFromSuggestedToken:(id)token ofType:(OPFQuestionsViewControllerTokenBeingInputtedType)type
{
	NSString *tokenText = nil;
	if (type == kOPFQuestionsViewControllerTokenBeingInputtedTag) {
		OPFTag *tag = (OPFTag *)token;
		tokenText = tag.name;
	} else if (type == kOPFQuestionsViewControllerTokenBeingInputtedUser) {
		OPFUser *user = (OPFUser *)token;
		tokenText = user.displayName;
	} else if (type == kOPFQuestionsViewControllerTokenBeingInputtedNone) {
		tokenText = @"";
	} else {
		ZAssert(NO, @"Unkown type of token being inputted, got: %d", self.tokenBeingInputtedType);
	}
	return tokenText;
}

- (NSString *)tokenTextFromSuggestedTokenAtIndexPath:(NSIndexPath *)indexPath
{
	id token = self.suggestedTokens[indexPath.row];
	NSString *tokenText = [self tokenTextFromSuggestedToken:token ofType:self.tokenBeingInputtedType];
	return tokenText;
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
	NSString *tokenText = [self tokenTextFromSuggestedTokenAtIndexPath:indexPath];
	[self didSelectToken:tokenText];
}


#pragma mark - Token Handling
- (void)didSelectToken:(NSString *)tokenString
{
	[self.tokenBeingInputted setString:tokenString];
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
		NSUInteger location = tokenStartRange.location + tokenStartRange.length;
		NSUInteger length = ((tokenEndRange.location != NSNotFound && tokenEndRange.location > tokenStartRange.location) ? tokenEndRange.location - location : searchString.length - location);
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

- (void)selectBestTokenMatchAndEndSearch
{
	if ((self.tokenBeingInputtedType == kOPFQuestionsSearchBarTokenStyleTag ||
		 self.tokenBeingInputtedType == kOPFQuestionsSearchBarTokenStyleUser) &&
		self.tokenBeingInputted.length > 0 &&
		self.suggestedTokens.count > 0) {
		id token = self.suggestedTokens[0];
		NSString *tokenText = [self tokenTextFromSuggestedToken:token ofType:self.tokenBeingInputtedType];
		[self didSelectToken:tokenText];
	}
	
	[self dismissSearchBarExtras];
}


#pragma mark - UISearchBarDelegate Methods
- (OPFQuestionsSearchBar *)searchBar
{
	return self.searchBarHeader.searchBar;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if (!self.searchString.length && searchText.length > 0)
		self.searchBarHeader.sortOrderControl.selectedSegmentIndex = kOPFScore;
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
	[self selectBestTokenMatchAndEndSearch];
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


#pragma mark - UIScrollBarDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	OPFUIScrollViewDirection direction = scrollView.opf_scrollViewScrollingDirection;
	if (direction & kOPFUIScrollViewDirectionDown) {
		[self selectBestTokenMatchAndEndSearch];
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

@end
