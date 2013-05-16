//
//  OPFTagBrowserCollectionView.h
//  Code Stream
//
//  Created by Tobias Deekens on 06.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFBarGradientView;

@interface OPFTagBrowserCollectionView : UIView;
@property (strong, nonatomic) IBOutlet UICollectionView *headerCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet OPFBarGradientView *footerGradientView;
@property (strong, nonatomic) IBOutlet OPFBarGradientView *headerGradientView;
@property (strong, nonatomic) IBOutlet UIButton *questionInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionCountLabel;

@end
