//
//  OPFTagBrowserViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 06.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <BlocksKit.h>

#import "OPFTagBrowserViewController.h"
#import "OPFTag.h"
#import "OPFQuestion.h"
#import "OPFQuery.h"
#import "OPFTokenCollectionViewCell.h"
#import "OPFTagBrowserCollectionViewHeaderInitial.h"
#import "OPFTagBrowserCollectionViewHeaderTag.h"
#import "OPFTagBrowserCollectionView.h"
#import "OPFQuestionsViewController.h"
#import "OPFTagBrowserSelectionViewController.h"

#import <THIn.h>

@interface OPFTagBrowserViewController ()

@property (strong) NSMutableArray *suggestedTags;
@property (strong) NSMutableArray *questionsByTag;
@property (strong) OPFQuery *questionsQuery;
@property (strong) OPFTagBrowserSelectionViewController *selectedTagsController;

@property (strong) NSIndexPath *lastTappedIndexPath;
@property (strong) THInWeakTimer *singleTapDelayTimer;

- (OPFTag *)tagFromIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectTag:(OPFTag *)tag;
- (void)didDoubleTapTag:(id)sender;
- (void)loadQuestionsForTags;
- (void)setResultCountInView;
- (NSArray *)getTagNames;
- (void) hideFooterLabels;
- (void) showFooterLabels;

@end

@implementation OPFTagBrowserViewController

static NSString *const OPFTagBrowserCellViewIdenfifier = @"OPFTagBrowserCollectionViewCell";
static NSString *const OPFTagBrowserHeaderViewInitialIdenfifier = @"OPFTagBrowserCollectionViewInitial";
static NSString *const OPFTagBrowserHeaderViewTagIdenfifier = @"OPFTagBrowserCollectionViewTag";
static NSInteger const OPFTagSuggestionLimit = 100;
static NSInteger const OPFTagLoadingByTagLimit = 50;
static NSInteger const OPFTagSelectionLimit = 20;
static NSTimeInterval const OPFDoubleTapDelay = 0.2;

- (id)init
{
    self = [super initWithNibName:@"OPFTagBrowserCollectionView" bundle:nil];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)opfSetupView
{
    self.title = NSLocalizedString(@"Tag Browser", @"Tag Browser View controller title");
    self.selectedTagsController = [OPFTagBrowserSelectionViewController new];
    
    self.selectedTags = [NSMutableSet setWithCapacity:OPFTagSuggestionLimit];
    self.selectedTagsController.tags = [NSMutableArray arrayWithCapacity:OPFTagSuggestionLimit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.footerTagCountButton.hidden = YES;
	self.footerTagCountLabel.enabled = NO;
	[self.footerTagCountLabel setTitle:NSLocalizedString(@"No tags selected", @"No tags selected button title") forState:UIControlStateDisabled];
	
    [self.collectionView registerClass:OPFTagTokenCollectionViewCell.class forCellWithReuseIdentifier:OPFTagBrowserCellViewIdenfifier];
    [self.collectionView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFTagBrowserCollectionViewHeaderInitial) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OPFTagBrowserHeaderViewInitialIdenfifier];
    [self.collectionView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFTagBrowserCollectionViewHeaderTag) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OPFTagBrowserHeaderViewTagIdenfifier];
    
    if (self.adjacentTag != nil) {
        self.suggestedTags = [NSMutableArray arrayWithArray:[OPFTag relatedTagsForTagWithName:self.adjacentTag.name]];
        [self loadQuestionsForTags];
    } else {
        self.suggestedTags = [NSMutableArray arrayWithArray:[[[OPFTag mostCommonTagsQuery] limit:@(OPFTagSuggestionLimit)] getMany]];
    }
    
    self.selectedTagsView.dataSource = self.selectedTagsController;
    self.selectedTagsView.delegate = self.selectedTagsController;
    self.selectedTagsController.parent = self;
    self.selectedTagsController.view = self.selectedTagsView;
    self.selectedTagsController.collectionView = self.selectedTagsView;
    [self.selectedTagsController.collectionView registerClass:OPFTagTokenCollectionViewCell.class forCellWithReuseIdentifier:OPFTagBrowserCellViewIdenfifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectedTags:(NSMutableSet *)selectedTags
{
    _selectedTags = selectedTags;
    [self.selectedTagsController.tags addObjectsFromArray:[self.selectedTags allObjects]];
}

- (void)didSelectSelectedTag:(OPFTag *)tag
{
    [self.selectedTagsController.tags removeObject:tag];
    [self.selectedTags removeObject:tag];
    
	[self.suggestedTags addObject:tag];
	[self.suggestedTags sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"counter" ascending:NO] ]];
	NSUInteger tagIndex = [self.suggestedTags indexOfObject:tag];
	NSIndexPath *insertedTagIndexPath = [NSIndexPath indexPathForItem:tagIndex inSection:0];
	[self.collectionView insertItemsAtIndexPaths:@[ insertedTagIndexPath ]];
	
    if (self.selectedTags.count == 0) {
        [self hideFooterLabels];
    }
    
    [self loadQuestionsForTags];
}

#pragma mark - Private methods

- (OPFTag *)tagFromIndexPath:(NSIndexPath *)indexPath
{
    return [self.suggestedTags objectAtIndex:indexPath.row];
}

- (void)selectTagAtIndexPath:(NSIndexPath *)indexPath
{
	[self didSelectTag:[self tagFromIndexPath:indexPath]];
	
	[self.suggestedTags removeObject:[self tagFromIndexPath:indexPath]];
	[self.collectionView deleteItemsAtIndexPaths:@[ indexPath ]];
}

- (void)didSelectTag:(OPFTag *)tag
{
    //I know its a set with unique items but i need to know if its a new tag
    if (! [self.selectedTags containsObject:tag]) {
        [self.selectedTagsController.tags addObject:tag];
		NSIndexPath *insertedTagIndexPath = [NSIndexPath indexPathForItem:self.selectedTagsController.tags.count - 1 inSection:0];
		[self.selectedTagsView insertItemsAtIndexPaths:@[ insertedTagIndexPath ]];
    }
    
    [self.selectedTags addObject:tag];
	
	[self loadQuestionsForTags];
}


- (void)didDoubleTapTag:(OPFTag *)tag
{
    OPFTagBrowserViewController *nestedTagController = [OPFTagBrowserViewController new];
    nestedTagController.adjacentTag = tag;
    nestedTagController.selectedTags = self.selectedTags;
    
    [self.navigationController pushViewController:nestedTagController animated:YES];
}

- (void)loadQuestionsForTags
{
    self.questionsQuery = [[OPFQuestion searchFor:@"" inTags:[self getTagNames]] orderBy:@"score" order:kOPFSortOrderDescending];
    
    self.questionsByTag = [NSMutableArray arrayWithArray:[[self.questionsQuery limit:@(OPFTagSuggestionLimit)] getMany]];
    
    [self setResultCountInView];
}

- (void)setResultCountInView
{
	NSUInteger questionsCount = self.questionsByTag.count;
	NSUInteger tagsCount = self.selectedTags.count;
	
	NSString *questionCountText = (questionsCount >= OPFTagLoadingByTagLimit) ? [NSString stringWithFormat:@"%lu+", (long)OPFTagLoadingByTagLimit] : [NSString stringWithFormat:@"%lu", (unsigned long)self.questionsByTag.count];
	NSString *questionsText = (questionsCount != 1 ? @"questions" : @"question");
	NSString *tagsText = (tagsCount != 1 ? @"tags" : @"tag");
	
	NSString *title = [NSString localizedStringWithFormat:@"%@ %@ matching %d %@", questionCountText, questionsText, tagsCount, tagsText];
	[self.footerTagCountLabel setTitle:title forState:UIControlStateNormal];
	[self.footerTagCountLabel setNeedsDisplay];
	
    [self showFooterLabels];
}

- (NSArray *)getTagNames
{
    NSArray *tags = [NSArray arrayWithArray:[self.selectedTags allObjects]];
    NSArray *tagNames = [tags map:^(OPFTag *tag) { return tag.name; }];
    
    return tagNames;
}

- (void)hideFooterLabels
{
    dispatch_async(dispatch_get_main_queue(), ^{
		self.footerTagCountButton.hidden = YES;
		self.footerTagCountLabel.enabled = NO;
    });
}

- (void)showFooterLabels
{
	self.footerTagCountButton.hidden = NO;
	self.footerTagCountLabel.enabled = YES;
}

#pragma mark - TabbedViewController methods

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"tab-tagbrowser";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    //Tag browser as title does not fit! Oh noeees!
    return NSLocalizedString(@"Tags", @"Tag Browser View controller tab title");
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.suggestedTags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	OPFTokenCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:OPFTagBrowserCellViewIdenfifier forIndexPath:indexPath];
	NSString *token = [self tagFromIndexPath:indexPath].name;
    
	cell.tokenView.text = token;
    
	return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * headerView = nil;
    
    if (kind == UICollectionElementKindSectionHeader && self.adjacentTag == nil) {
        OPFTagBrowserCollectionViewHeaderInitial *initialHeaderView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                              withReuseIdentifier:OPFTagBrowserHeaderViewInitialIdenfifier
                                                                                                                     forIndexPath:indexPath];
        
        initialHeaderView.tagCount.text = [NSString stringWithFormat:@"%ld", (long)OPFTagSuggestionLimit];
        
        headerView = initialHeaderView;
    } else if (kind == UICollectionElementKindSectionHeader && [self.adjacentTag isKindOfClass:OPFTag.class]) {
        OPFTagBrowserCollectionViewHeaderTag *tagHeaderView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                      withReuseIdentifier:OPFTagBrowserHeaderViewTagIdenfifier
                                                                                                             forIndexPath:indexPath];
        
        tagHeaderView.tagName.text = self.adjacentTag.name;
        
        headerView = tagHeaderView;
    }
    
    return headerView;
}


#pragma mark - UICollectionViewFlowLayout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *token = [self tagFromIndexPath:indexPath].name;
	CGSize tokenSize = [token sizeWithFont:[UIFont systemFontOfSize:kOPFTokenTextFontSize]];
	
	CGFloat width = kOPFTokenPaddingLeft + tokenSize.width + kOPFTokenPaddingRight;
	CGFloat height = kOPFTokenHeight;
	
	CGSize size = CGSizeMake(width, height);
	return size;
}


#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self.lastTappedIndexPath isEqual:indexPath]) {
		[self.singleTapDelayTimer invalidate];
		self.singleTapDelayTimer = nil;
		self.lastTappedIndexPath = nil;
		
		[self didDoubleTapTag:[self tagFromIndexPath:indexPath]];
	} else {
		if (self.lastTappedIndexPath != nil) {
			[self.singleTapDelayTimer invalidate];
			self.singleTapDelayTimer = nil;
			
			[self selectTagAtIndexPath:indexPath];
		}
		
		self.lastTappedIndexPath = indexPath;
		self.singleTapDelayTimer = [[THInWeakTimer alloc] initWithDelay:OPFDoubleTapDelay do:^{
			self.lastTappedIndexPath = nil;
			
			[self selectTagAtIndexPath:indexPath];
		}];
	}
}


#pragma mark - IBActions
- (IBAction)showQuestionsByTags:(UIControl *)sender
{
    OPFQuestionsViewController *questionsViewController = [OPFQuestionsViewController new];
    
    NSString *searchString = [NSString stringWithFormat:@"[%@]", [[self getTagNames] componentsJoinedByString:@"] ["]];
    
    questionsViewController.query = self.questionsQuery;
    questionsViewController.searchString = searchString;
    
    [self.navigationController pushViewController:questionsViewController animated:YES];
}

@end
