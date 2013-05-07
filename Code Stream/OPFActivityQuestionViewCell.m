//
//  OPFActivityQuestionViewCell.m
//  Code Stream
//
//  Created by Tobias Deekens on 05.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFActivityQuestionViewCell.h"
#import "OPFQuestion.h"
#import "NSString+OPFStripCharacters.h"
#import "NSString+OPFEscapeStrings.h"
#import "OPFScoreNumberFormatter.h"

@interface OPFActivityQuestionViewCell()

@property(nonatomic, strong) OPFScoreNumberFormatter *scoreFormatter;

- (void)opfSetupView;

@end

@implementation OPFActivityQuestionViewCell

@synthesize questionModel = _questionModel;

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
     self.scoreFormatter = [OPFScoreNumberFormatter new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuestionModel:(OPFQuestion *)questionModel
{
    _questionModel = questionModel;
    
    [self setModelValuesInView];
}

- (OPFQuestion *)questionModel
{
    return _questionModel;
}

- (void)setModelValuesInView
{
    self.commentCount.text = [self.scoreFormatter stringFromScore:[self.questionModel.commentCount integerValue]];
    self.answerCount.text = [self.scoreFormatter stringFromScore:[self.questionModel.answerCount integerValue]];
    self.viewCount.text = [self.scoreFormatter stringFromScore:[self.questionModel.viewCount integerValue]];
    self.scoreCount.text = [self.scoreFormatter stringFromScore:[self.questionModel.score integerValue]];
    
    self.questionTitle.text = self.questionModel.title;
    self.questionBody.text = [self.questionModel.body.opf_stringByStrippingHTML OPF_escapeWithScheme:OPFStripAscii];

    if(self.questionModel.acceptedAnswerId == nil) {
        self.acceptedAnswer.hidden = YES;
    }
}

@end
