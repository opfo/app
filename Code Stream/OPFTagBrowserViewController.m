//
//  OPFTagBrowserViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 06.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTagBrowserViewController.h"
#import "OPFTag.h"
#import "OPFQuestion.h"
#import "OPFQuery.h"
#import "OPFTokenCollectionViewCell.h"
#import "OPFTagBrowserCollectionViewHeaderInitial.h"
#import "OPFTagBrowserCollectionView.h"

@interface OPFTagBrowserViewController ()

@property (strong) NSMutableArray *suggestedTags;
@property (strong) NSMutableArray *questionsByTag;

- (OPFTag *)tagFromIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectTag:(OPFTag *)tag;
- (void)loadQuestionsForTag:(OPFTag *)tag;
- (void)setResultCountInView;

@end

@implementation OPFTagBrowserViewController

static NSString *const TagBrowserCellViewIdenfifier = @"OPFTagBrowserCollectionViewCell";
static NSString *const TagCountLabel = @"Question(s) matching tag(s)";
static NSString *const TagBrowserHeaderViewIdenfifier = @"OPFTagBrowserCollectionViewInitial";
static NSInteger const TagSuggestionLimit = 100;
static NSInteger const TagLoadingByTagLimit = 50;

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
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.suggestedTags = [NSMutableArray arrayWithArray:[[[OPFTag mostCommonTagsQuery] limit:@(TagSuggestionLimit)] getMany]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (OPFTag *)tagFromIndexPath:(NSIndexPath *)indexPath
{
    return [self.suggestedTags objectAtIndex:indexPath.row];
}

- (void)didSelectTag:(OPFTag *)tag
{
	[self loadQuestionsForTag:tag];
}

- (void)loadQuestionsForTag:(OPFTag *)tag
{
    OPFQuery *query = [[OPFQuestion searchFor:@"" inTags:@[tag.name]] orderBy:@"score" order:kOPFSortOrderDescending];
    
    self.questionsByTag = [NSMutableArray arrayWithArray:[[query limit:@(TagLoadingByTagLimit)] getMany]];
    
    [self setResultCountInView];
}

- (void)setResultCountInView
{
    self.footerTagCount.text = (self.questionsByTag.count >= TagLoadingByTagLimit) ? [NSString stringWithFormat:@"%lu+", (long)TagLoadingByTagLimit] : [NSString stringWithFormat:@"%lu", (unsigned long)self.questionsByTag.count];
    self.footerTagCountLabel.titleLabel.text = TagCountLabel;
    
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

@end
