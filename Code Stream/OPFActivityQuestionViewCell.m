//
//  OPFActivityQuestionViewCell.m
//  Code Stream
//
//  Created by Tobias Deekens on 05.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFActivityQuestionViewCell.h"
#import "OPFQuestion.h"

@implementation OPFActivityQuestionViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self opfSetupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

- (void)opfSetupView
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuestionModel:(OPFQuestion *)questionModel
{
    self.questionModel = questionModel;
    
    [self setModelValuesInView];
}

- (void)setModelValuesInView
{
    self.questionTitle.text = self.questionModel.title;
    self.questionBody.text = self.questionModel.body;
}

@end
