//
//  OPFActivityQuestionViewCell.h
//  Code Stream
//
//  Created by Tobias Deekens on 05.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFQuestion;

@interface OPFActivityQuestionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *questionTitle;
@property (weak, nonatomic) IBOutlet UITextView *questionBody;

@property(nonatomic, strong) OPFQuestion *questionModel;

- (void)setModelValuesInView;

@end
