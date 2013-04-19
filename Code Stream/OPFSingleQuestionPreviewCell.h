//
//  OPFSingleQuestionPreviewCell.h
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFQuestion.h"

@interface OPFSingleQuestionPreviewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger answers;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, assign) BOOL acceptedAnswer;


- (id) configureWithQuestionData:(OPFQuestion *)question;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *answersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *acceptedAnswerImage;


@end
