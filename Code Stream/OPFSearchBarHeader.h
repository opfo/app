//
//  OPFSearchBarHeader.h
//  Code Stream
//
//  Created by Martin Goth on 2013-05-07.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFQuestionsSearchBar.h"

typedef enum {SearchBar = 0, SortControl = 1} DisplayHeader;

typedef enum {Score, Activity, Created} SortOrder;

@interface OPFSearchBarHeader : UIScrollView
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderControl;
@property (weak, nonatomic) IBOutlet OPFQuestionsSearchBar *searchBar;

@property (nonatomic) DisplayHeader displayedHeader;
-(void)setDisplayedHeader:(DisplayHeader)page WithAnimation:(BOOL) animated;



- (IBAction)handleSwitchEvent:(UIButton *)sender;

@end
