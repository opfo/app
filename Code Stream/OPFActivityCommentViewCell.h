//
//  OPFActivityCommentViewCell.h
//  Code Stream
//
//  Created by Tobias Deekens on 05.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFComment;

@interface OPFActivityCommentViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *commentBody;
@property (weak, nonatomic) IBOutlet UILabel *scoreCount;

@property(nonatomic, strong) OPFComment *commentModel;

- (void)setModelValuesInView;

@end
