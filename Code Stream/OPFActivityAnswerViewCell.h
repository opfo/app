//
//  OPFActivityAnswerViewCell.h
//  Code Stream
//
//  Created by Tobias Deekens on 05.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFAnswer;

@interface OPFActivityAnswerViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *answerTitle;
@property (weak, nonatomic) IBOutlet UITextView *answerBody;
@property (weak, nonatomic) IBOutlet UIImageView *acceptedAnswer;
@property (weak, nonatomic) IBOutlet UILabel *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreCount;

@property(nonatomic, strong) OPFAnswer *answerModel;

- (void)setModelValuesInView;

@end
