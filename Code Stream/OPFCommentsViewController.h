//
//  OPFCommentViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFPost;

@interface OPFCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *commentTableView;
}

@property(nonatomic, strong) NSArray *commentModels;
@property(nonatomic, strong) OPFPost *postModel;

- (void)voteUpComment:(UIButton *)sender;

@end