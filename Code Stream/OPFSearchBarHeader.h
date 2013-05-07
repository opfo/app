//
//  OPFSearchBarHeader.h
//  Code Stream
//
//  Created by Martin Goth on 2013-05-07.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFQuestionsSearchBar.h"

typedef enum {SearchBar = 2, SortControl = 1} DisplayHeader;

@interface OPFSearchBarHeader : UIScrollView <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderControl;
@property (weak, nonatomic) IBOutlet UIButton *switchToSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *switchToSortButton;
@property (weak, nonatomic) IBOutlet OPFQuestionsSearchBar *searchBar;

- (void)configureView;

- (IBAction)handleSwitchEvent:(UIButton *)sender;
@property (nonatomic) DisplayHeader headerDisplayed;

@end
