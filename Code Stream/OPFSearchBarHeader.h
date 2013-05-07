//
//  OPFSearchBarHeader.h
//  Code Stream
//
//  Created by Martin Goth on 2013-05-07.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFQuestionsSearchBar.h"

@interface OPFSearchBarHeader : UIView
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderControl;
@property (weak, nonatomic) IBOutlet UIButton *searchBarButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet OPFQuestionsSearchBar *searchBar;

@end
