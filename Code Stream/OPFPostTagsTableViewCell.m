//
//  OPFPostTagsTableViewCell.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostTagsTableViewCell.h"
#import "OPFTokenCollectionViewCell.h"
#import <BlocksKit.h>

@implementation OPFPostTagsTableViewCell

static NSString *const TagCellIdentifier = @"TagCellIdentifier";

- (void)awakeFromNib
{
	self.tagsCollectionView.backgroundColor = UIColor.clearColor;
	[self.tagsCollectionView registerClass:OPFTagTokenCollectionViewCell.class forCellWithReuseIdentifier:TagCellIdentifier];
	
	UICollectionViewFlowLayout *completionsViewLayout = (UICollectionViewFlowLayout *)self.tagsCollectionView.collectionViewLayout;
	completionsViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	completionsViewLayout.minimumInteritemSpacing = 10.f;
	completionsViewLayout.sectionInset = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
}

- (void)prepareForReuse
{
	[self.tagsCollectionView setContentOffset:CGPointZero animated:NO];
	self.didSelectTagBlock = nil;
	_tags = nil;
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
	CGFloat width = CGRectGetWidth(bounds);
	
	CGRect tagsCollectionFrame = self.tagsCollectionView.frame;
	tagsCollectionFrame.size.width = width;
	tagsCollectionFrame.origin.x = 0.f;
	self.tagsCollectionView.frame = tagsCollectionFrame;
}

- (void)setTags:(NSArray *)tags
{
	if (_tags != tags) {
		_tags = tags.copy;
		[self.tagsCollectionView reloadData];
	}
}

#pragma mark - UICollectionViewDataSource
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
	OPFTagTokenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCellIdentifier forIndexPath:indexPath];
	NSString *tagName = self.tags[indexPath.row];
	cell.tokenView.text = tagName;
	cell.shouldDrawShadow = NO;
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.didSelectTagBlock != nil) {
		NSString *tagName = self.tags[indexPath.row];
		self.didSelectTagBlock(tagName);
	}
}


#pragma mark - UICollectionViewFlowLayout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *tagName = self.tags[indexPath.row];
	CGSize tokenSize = [tagName sizeWithFont:[UIFont systemFontOfSize:kOPFTokenTextFontSize]];
	
	CGFloat width = kOPFTokenPaddingLeft + tokenSize.width + kOPFTokenPaddingRight;
	CGFloat height = kOPFTokenHeight;
	
	CGSize size = CGSizeMake(width, height);
	return size;
}


@end
