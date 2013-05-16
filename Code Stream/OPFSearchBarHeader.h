//
//  OPFSearchBarHeader.h
//  Code Stream
//
//  Created by Martin Goth on 2013-05-07.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFQuestionsSearchBar.h"

typedef enum {kOPFSearchBar = 0, kOPFSortControl = 1} kOPFDisplayHeader;

typedef enum {kOPFScore, kOPFActivity, kOPFCreated} kOPFSortOrder;

@interface OPFSearchBarHeader : UIScrollView
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderControl;
@property (weak, nonatomic) IBOutlet OPFQuestionsSearchBar *searchBar;

@property (nonatomic) kOPFDisplayHeader displayedHeader;
-(void)setDisplayedHeader:(kOPFDisplayHeader)page WithAnimation:(BOOL) animated;



- (IBAction)handleSwitchEvent:(UIButton *)sender;

@end
