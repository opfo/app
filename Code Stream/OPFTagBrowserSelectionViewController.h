//
//  OPFTagBrowserSelectionViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 13.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFTagBrowserSelectionViewController : UIViewController <UICollectionViewDataSource,
UICollectionViewDelegate>

@property(strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) UICollectionView *collectionView;

@end
