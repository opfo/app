//
//  OPFPostTagsTableViewCell.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostTagsTableViewCell.h"
#import "OPFTokenCollectionViewCell.h"
#import "UIColor+OPFHEX.h"
#import <SSLineView.h>


@interface OPFPostTagsTableViewCell (/*Private*/)
@property (strong, nonatomic) SSLineView *bottomBorderView;
@end


@implementation OPFPostTagsTableViewCell

static NSString *const TagCellIdentifier = @"TagCellIdentifier";

static OPFPostTagsTableViewCell *sharedInit(OPFPostTagsTableViewCell *self) {
	if (self) {
		SSLineView *bottomBorderView = [[SSLineView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 1.f)];
		bottomBorderView.lineColor = [UIColor opf_colorWithHexValue:0xe0e0e0];
		bottomBorderView.insetColor = nil;
		bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self->_bottomBorderView = bottomBorderView;
		[self addSubview:self->_bottomBorderView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	return sharedInit(self);
}

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
	
	CGRect bottomBorderFrame = self.bottomBorderView.frame;
	bottomBorderFrame.size.width = width;
	bottomBorderFrame.origin.y = CGRectGetHeight(bounds) - CGRectGetHeight(bottomBorderFrame);
	self.bottomBorderView.frame = bottomBorderFrame;
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
