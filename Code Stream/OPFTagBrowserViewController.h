//
//  OPFTagBrowserViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 06.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFTagBrowserViewController : UICollectionViewController <UICollectionViewDataSource,
UICollectionViewDelegate>

- (NSString *)tabImageName;
- (NSString *)tabTitle;

@end
