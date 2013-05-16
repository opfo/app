//
//  OPFPostTagsTableViewCell.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^OPFPostTagsDidSelectTagBlock)(NSString *tagName);


@interface OPFPostTagsTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (copy, nonatomic) NSArray *tags;
@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;

@property (copy, nonatomic) OPFPostTagsDidSelectTagBlock didSelectTagBlock;

@end
