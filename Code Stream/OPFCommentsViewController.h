//
//  OPFCommentViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFCommentsViewController : UITableViewController {
    IBOutlet UITableView *commentTableView;
}

@property(nonatomic, strong) NSArray *commentModels;

- (void)voteUpComment:(UIButton *)sender;

@end