//
//  OPFSingleQuestionPreviewCell.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSingleQuestionPreviewCell.h"

@implementation OPFSingleQuestionPreviewCell
@synthesize score = _score;
@synthesize title = _title;
@synthesize answers = _answers;



- (id)configureWithQuestionData:(OPFQuestion *)question {
	self.acceptedAnswer = question.acceptedAnswer != nil;
	self.score = question.score;
	self.answers = question.answerCount;
	self.title = question.title;
	
	self.tags = @[@"test1", @"test2", @"test3"];
	self.tagList.dataSource = self;
	[self.tagList reloadData];
	
	// [self addObserver:self forKeyPath:@"tags" options:0 context:nil];
	
	return self;
}

- (NSInteger)numberOfTagLabelInTagList:(GCTagList *)tagList {
	return self.tags.count;
}

- (GCTagLabel *)tagList:(GCTagList *)tagList tagLabelAtIndex:(NSInteger)index {
	
	static NSString* identifier = @"TagLabelIdentifier";
	
    GCTagLabel* tag = [tagList dequeueReusableTagLabelWithIdentifier:identifier];
    if(!tag) {
        tag = [GCTagLabel tagLabelWithReuseIdentifier:identifier];
        tag.labelBackgroundColor = [UIColor colorWithRed:84/255.f green:164/255.f blue:222/255.f alpha:1.f];
		
    }
	
    [tag setLabelText:self.tags[index]
        accessoryType:GCTagLabelAccessoryCrossFont];
	
    return tag;
}

- (void)setAcceptedAnswer:(BOOL)acceptedAnswer {
	self.acceptedAnswerImage.hidden = !acceptedAnswer;
}

- (BOOL)acceptedAnswer {
	return !self.acceptedAnswerImage.hidden;
}

- (void)setScore:(NSInteger)Score {
	_score = Score;
	
	if (Score >= 1000) {
		self.scoreLabel.text = [NSString stringWithFormat: @"%1.1fk", (double)Score / 1000.0];
	} else {
		self.scoreLabel.text = [NSString stringWithFormat:@"%d", Score];
	}
}

- (void)setAnswers:(NSInteger)Answers {
	_answers = Answers;
	self.answersLabel.text = [NSNumber numberWithInteger:Answers].stringValue;
}

- (void)setTitle:(NSString *)Title {
	_title = Title;
	self.questionLabel.text = Title;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
	
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}



@end
