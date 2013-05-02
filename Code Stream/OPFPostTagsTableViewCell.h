//
//  OPFPostTagsTableViewCell.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTagList.h"


@class GCTagList;

@interface OPFPostTagsTableViewCell : UITableViewCell <GCTagListDataSource>

@property (copy) NSArray *tags;
@property (weak, nonatomic) IBOutlet GCTagList *tagsView;


@end
