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
#import "OPFTagBrowserCollectionView.h"
#import "OPFQuestionsViewController.h"
#import "OPFTagBrowserSelectionViewController.h"

@interface OPFTagBrowserViewController ()

@property (strong) NSMutableArray *suggestedTags;
@property (strong) NSMutableArray *questionsByTag;
@property (strong) OPFQuery *questionsQuery;
@property (strong) OPFTagBrowserSelectionViewController *selectedTagsController;

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

static NSString *const TagBrowserCellViewIdenfifier = @"OPFTagBrowserCollectionViewCell";
static NSString *const TagBrowserHeaderViewIdenfifier = @"OPFTagBrowserCollectionViewInitial";
static NSString *const TagCountLabel = @"Question(s) matching tag(s)";
static NSInteger const TagSuggestionLimit = 100;
static NSInteger const TagLoadingByTagLimit = 50;
static NSInteger const TagSelectionLimit = 20;

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
    
    self.selectedTags = [NSMutableSet setWithCapacity:TagSelectionLimit];
    self.selectedTagsController.tags = [NSMutableArray arrayWithCapacity:TagSelectionLimit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:OPFTagTokenCollectionViewCell.class forCellWithReuseIdentifier:TagBrowserCellViewIdenfifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFTagBrowserCollectionViewHeaderInitial) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagBrowserHeaderViewIdenfifier];
    
    if (self.adjacentTag != nil) {
        self.suggestedTags = [NSMutableArray arrayWithArray:[OPFTag relatedTagsForTagWithName:self.adjacentTag.name]];
        [self loadQuestionsForTags];
    } else {
        self.suggestedTags = [NSMutableArray arrayWithArray:[[[OPFTag mostCommonTagsQuery] limit:@(TagSuggestionLimit)] getMany]];
    }
    
    self.selectedTagsView.dataSource = self.selectedTagsController;
    self.selectedTagsView.delegate = self.selectedTagsController;
    self.selectedTagsController.parent = self;
    self.selectedTagsController.view = self.selectedTagsView;
    self.selectedTagsController.collectionView = self.selectedTagsView;
    [self.selectedTagsController.collectionView registerClass:OPFTagTokenCollectionViewCell.class forCellWithReuseIdentifier:TagBrowserCellViewIdenfifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //Setup handling of double taps
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapTag:)];
    NSArray* recognizers = [self.collectionView gestureRecognizers];
    
    // Make the default gesture recognizer wait until the custom one fails.
    for (UIGestureRecognizer* aRecognizer in recognizers) {
        if ([aRecognizer isKindOfClass:[UITapGestureRecognizer class]])
            [aRecognizer requireGestureRecognizerToFail:tapGesture];
    }
    
    // Now add the gesture recognizer to the collection view.
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.numberOfTouchesRequired = 1;
    [self.collectionView addGestureRecognizer:tapGesture];
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
    
    [self.selectedTagsView reloadData];
    
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

- (void)didSelectTag:(OPFTag *)tag
{
    //I know its a set with unique items but i need to know if its a new tag
    if (! [self.selectedTags containsObject:tag]) {
        [self.selectedTagsController.tags addObject:tag];
        [self.selectedTagsView reloadData];
    }
    
    [self.selectedTags addObject:tag];
    
	[self loadQuestionsForTags];
}

- (void)didDoubleTapTag:(id)sender
{
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    OPFTag *tag = [self tagFromIndexPath:indexPath];
    
    OPFTagBrowserViewController *nestedTagController = [OPFTagBrowserViewController new];
    nestedTagController.adjacentTag = tag;
    nestedTagController.selectedTags = self.selectedTags;
    
    [self.navigationController pushViewController:nestedTagController animated:YES];
}

- (void)loadQuestionsForTags
{
    self.questionsQuery = [[OPFQuestion searchFor:@"" inTags:[self getTagNames]] orderBy:@"score" order:kOPFSortOrderDescending];
    
    self.questionsByTag = [NSMutableArray arrayWithArray:[[self.questionsQuery limit:@(TagLoadingByTagLimit)] getMany]];
    
    [self setResultCountInView];
}

- (void)setResultCountInView
{
    self.footerTagCount.text = (self.questionsByTag.count >= TagLoadingByTagLimit) ? [NSString stringWithFormat:@"%lu+", (long)TagLoadingByTagLimit] : [NSString stringWithFormat:@"%lu", (unsigned long)self.questionsByTag.count];
    self.footerTagCountLabel.titleLabel.text = TagCountLabel;
    
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
        self.footerTagCountLabel.hidden = self.footerTagCountButton.hidden = self.footerTagCount.hidden = YES;
    });
}

- (void)showFooterLabels
{
    self.footerTagCountLabel.hidden = self.footerTagCountButton.hidden = self.footerTagCount.hidden = NO;
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
	OPFTokenCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TagBrowserCellViewIdenfifier forIndexPath:indexPath];
	NSString *token = [self tagFromIndexPath:indexPath].name;
    
	cell.tokenView.text = token;
    
	return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    OPFTagBrowserCollectionViewHeaderInitial * headerView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                             withReuseIdentifier:TagBrowserHeaderViewIdenfifier
                                                                    forIndexPath:indexPath];
        
        headerView.tagCount.text = [NSString stringWithFormat:@"%ld", (long)TagSuggestionLimit];
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
	[self didSelectTag:[self tagFromIndexPath:indexPath]];
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
