//
//  OPFActivityAnswerViewCell.m
//  Code Stream
//
//  Created by Tobias Deekens on 05.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFActivityAnswerViewCell.h"
#import "OPFAnswer.h"

@implementation OPFActivityAnswerViewCell

@synthesize answerModel = _answerModel;

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

- (void)setAnswerModel:(OPFAnswer *)answerModel
{
    _answerModel = answerModel;
    
    [self setModelValuesInView];
}

- (OPFAnswer *)answerModel
{
    return _answerModel;
}

- (void)setModelValuesInView
{
    self.answerTitle.text = self.answerModel.parent.title;
    self.answerBody.text = self.answerModel.body;
}

@end
