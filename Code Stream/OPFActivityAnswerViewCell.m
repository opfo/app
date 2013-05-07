//
//  OPFActivityAnswerViewCell.m
//  Code Stream
//
//  Created by Tobias Deekens on 05.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFActivityAnswerViewCell.h"
#import "OPFAnswer.h"
#import "NSString+OPFStripCharacters.h"
#import "NSString+OPFEscapeStrings.h"
#import "OPFScoreNumberFormatter.h"

@interface OPFActivityAnswerViewCell()

@property(nonatomic, strong) OPFScoreNumberFormatter *scoreFormatter;

- (void)opfSetupView;

@end

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
     self.scoreFormatter = [OPFScoreNumberFormatter new];
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
    self.commentCount.text = [self.scoreFormatter stringFromScore:[self.answerModel.commentCount integerValue]];
    self.viewCount.text = [self.scoreFormatter stringFromScore:[self.answerModel.viewCount integerValue]];
    self.scoreCount.text = [self.scoreFormatter stringFromScore:[self.answerModel.score integerValue]];
    
    self.answerTitle.text = self.answerModel.parent.title;
    self.answerBody.text = [self.answerModel.body.opf_stringByStrippingHTML OPF_escapeWithScheme:OPFStripAscii];
    
    if(self.answerModel.identifier == self.answerModel.parent.acceptedAnswerId) {
        self.acceptedAnswer.image = [UIImage imageNamed:@"acceptedAnswer"];
    }
}

@end
