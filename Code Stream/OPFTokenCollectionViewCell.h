//
//  OPFTokenCollectionViewCell.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 02-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFQuestionsSearchBarTokenView.h"

@interface OPFTokenCollectionViewCell : UICollectionViewCell

- (instancetype)initWithStyle:(OPFQuestionsSearchBarTokenStyle)style;
@property (strong, readonly) OPFQuestionsSearchBarTokenView *tokenView;
@property (assign, nonatomic) BOOL shouldDrawShadow;

@end

@interface OPFTagTokenCollectionViewCell : OPFTokenCollectionViewCell @end
@interface OPFUserTokenCollectionViewCell : OPFTokenCollectionViewCell @end
