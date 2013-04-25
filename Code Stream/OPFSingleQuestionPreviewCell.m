//
//  OPFSingleQuestionPreviewCell.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSingleQuestionPreviewCell.h"


@implementation OPFSingleQuestionPreviewCell


#pragma mark Properties

@synthesize score = _score;
@synthesize title = _title;
@synthesize answers = _answers;


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

// KVO method for updating the tag view on change of the public property
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual: @"tags"]) {
		self.tagList.dataSource = self;
		[self.tagList reloadData];
	}
}


#pragma mark creationAndDestruction

- (void)configureWithQuestionData:(OPFQuestion *)question {
	self.acceptedAnswer = question.acceptedAnswer != nil;
	self.score = [question.score integerValue];
	self.answers = [question.answerCount integerValue];
	self.title = question.title;
	self.tags = @[@"test",@"test1"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.tagList.dataSource = self;
		// Add KVO-Observer for self.observeValueForKeyPath
		[self addObserver:self forKeyPath:@"tags" options:0 context:nil];
	}
	return self;
}

-(void)dealloc{
	[self removeObserver:self forKeyPath:@"tags"];
}


#pragma mark GCTagListDataSource

- (NSInteger)numberOfTagLabelInTagList:(GCTagList *)tagList {
	return self.tags.count;
}

// Initialization of the tags according to protocol
- (GCTagLabel *)tagList:(GCTagList *)tagList tagLabelAtIndex:(NSInteger)index {
	
	static NSString* identifier = @"TagLabelIdentifier";
    GCTagLabel* tag = [tagList dequeueReusableTagLabelWithIdentifier:identifier];
    if(!tag) {
        tag = [GCTagLabel tagLabelWithReuseIdentifier:identifier];
    }
	
    [tag setLabelText:self.tags[index] accessoryType:GCTagLabelAccessoryNone];
	return tag;
}

@end
