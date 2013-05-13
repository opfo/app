//
//  OPFTagBrowserViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 06.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFTagBrowserCollectionView, OPFTag;

@interface OPFTagBrowserViewController : UIViewController <UICollectionViewDataSource,
UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet OPFTagBrowserCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *footerTagCount;
@property (weak, nonatomic) IBOutlet UIButton *footerTagCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *footerTagCountButton;
@property (strong, nonatomic) IBOutlet UICollectionView *selectedTagsView;

@property (strong, nonatomic) OPFTag *adjacentTag;
@property (nonatomic, strong) NSMutableSet *selectedTags;

- (NSString *)tabImageName;
- (NSString *)tabTitle;
- (void)didSelectSelectedTag:(OPFTag *) tag;

- (IBAction)showQuestionsByTags:(id)sender;

@end
