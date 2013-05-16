//
//  OPFQuestionAnswersSeparatorView.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 14-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionAnswerSeparatorCell.h"

@interface OPFQuestionAnswerSeparatorCell (/*Private*/)
@property (weak, nonatomic) IBOutlet UILabel *backingTextLabel;
@end

@implementation OPFQuestionAnswerSeparatorCell

- (UILabel *)textLabel
{
	return self.backingTextLabel;
}

@end
