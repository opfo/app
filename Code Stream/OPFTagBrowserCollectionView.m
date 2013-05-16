//
//  OPFTagBrowserCollectionView.m
//  Code Stream
//
//  Created by Tobias Deekens on 06.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTagBrowserCollectionView.h"
#import "OPFTokenCollectionViewCell.h"
#import "OPFTagBrowserCollectionViewHeaderInitial.h"

@implementation OPFTagBrowserCollectionView

static NSString *const TagBrowserCellViewIdenfifier = @"OPFTagBrowserCollectionViewCell";
static NSString *const TagBrowserHeaderViewIdenfifier = @"OPFTagBrowserCollectionViewInitial";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
        [self registerClass:OPFTagTokenCollectionViewCell.class forCellWithReuseIdentifier:TagBrowserCellViewIdenfifier];
        
        [self registerNib:[UINib nibWithNibName:CDStringFromClass(OPFTagBrowserCollectionViewHeaderInitial) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TagBrowserHeaderViewIdenfifier];
	}
	return self;
}

@end
