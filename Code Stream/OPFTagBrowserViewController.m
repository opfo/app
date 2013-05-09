//
//  OPFTagBrowserViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 06.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTagBrowserViewController.h"
#import "OPFTag.h"
#import "OPFTokenCollectionViewCell.h"
#import "OPFTagBrowserCollectionViewHeaderInitial.h"

@interface OPFTagBrowserViewController ()

@property (strong) NSMutableArray *suggestedTokens;

- (OPFTag *)tagFromIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectToken:(OPFTag *)tag;

@end

@implementation OPFTagBrowserViewController

static NSString *const SuggestedTagCellIdentifier = @"SuggestedTagCellIdentifier";
static NSString *const TagBrowserHeaderViewIdenfifier = @"OPFTagBrowserCollectionViewInitial";
static NSInteger const TagSuggestionLimit = 100;

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
    
    [self.collectionView registerClass:OPFTagTokenCollectionViewCell.class forCellWithReuseIdentifier:SuggestedTagCellIdentifier];    
    [self.collectionView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFTagBrowserCollectionViewHeaderInitial) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagBrowserHeaderViewIdenfifier];
    
    self.suggestedTokens = [NSMutableArray arrayWithArray:[[[OPFTag mostCommonTagsQuery] limit:@(TagSuggestionLimit)] getMany]];
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
    return [self.suggestedTokens objectAtIndex:indexPath.row];
}

- (void)didSelectToken:(OPFTag *)tag
{
	
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
	return self.suggestedTokens.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = SuggestedTagCellIdentifier;
	OPFTokenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
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
	[self didSelectToken:[self tagFromIndexPath:indexPath]];
}

@end
