//
//  OPFTagBrowserSelectionViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 13.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTagBrowserSelectionViewController.h"
#import "OPFTokenCollectionViewCell.h"
#import "OPFTag.h"
#import "OPFTagBrowserViewController.h"

@interface OPFTagBrowserSelectionViewController ()

- (OPFTag *)tagFromIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectTag:(OPFTag *)tag;
- (void)opfSetupView;

@end

@implementation OPFTagBrowserSelectionViewController

static NSString *const TagBrowserCellViewIdenfifier = @"OPFTagBrowserCollectionViewCell";

- (id)init
{
    self = [super init];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

- (void)opfSetupView
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	OPFTokenCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TagBrowserCellViewIdenfifier forIndexPath:indexPath];
	NSString *token = [self tagFromIndexPath:indexPath].name;
    
	cell.tokenView.text = token;
    
	return cell;
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

#pragma mark - Private Methods
- (OPFTag *)tagFromIndexPath:(NSIndexPath *)indexPath
{
    return [self.tags objectAtIndex:indexPath.row];
}

- (void)didSelectTag:(OPFTag *)tag
{
    //Fix this tobi!
    [self.parent didSelectSelectedTag:tag];
}

@end
