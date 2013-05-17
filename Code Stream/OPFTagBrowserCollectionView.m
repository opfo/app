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
#import "SSLineView.h"
#import "OPFBarGradientView.h"
#import <QuartzCore/QuartzCore.h>

@interface OPFTagBrowserCollectionView()

@property(strong, nonatomic) SSLineView *topBorderView;
@property(strong, nonatomic) SSLineView *bottomBorderView;

@end

@implementation OPFTagBrowserCollectionView

- (void)awakeFromNib
{
	[self applyShadowToView:self.questionArrowImageView];
    
    self.footerGradientView.shouldDrawBottomBorder = NO;
    self.headerGradientView.shouldDrawTopBorder = NO;
}


- (void)applyShadowToView:(UIView *)view
{
	view.layer.shadowColor = UIColor.whiteColor.CGColor;
	view.layer.shadowOffset = CGSizeMake(0, 1);
	view.layer.shadowRadius = 0.f;
	view.layer.shadowOpacity = 1.f;
}

- (void)applyPropertiesOnLabel:(UILabel *)label
{
	[self applyShadowToView:label];
}

@end
