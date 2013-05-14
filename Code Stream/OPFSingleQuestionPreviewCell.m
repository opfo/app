//
//  OPFSingleQuestionPreviewCell.m
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFSingleQuestionPreviewCell.h"
#import "OPFQuestionsViewController.h"
#import "OPFUserPreviewButton.h"
#import "UIFont+OPFAppFonts.h"
#import "UIImage+OPFScoreImages.h"


@implementation OPFSingleQuestionPreviewCell {
	OPFScoreNumberFormatter *_numberFormatter;
}


#pragma mark Properties

@synthesize score = _score;
@synthesize title = _title;
@synthesize answers = _answers;


- (void)setScore:(NSInteger)score {
	if (_score != score) {
		_score = score;
		self.scoreLabel.text = [_numberFormatter stringFromScore:score];
	}
}

- (void)setAnswers:(NSInteger)answers {
	if (_answers != answers) {
		_answers = answers;
		self.answersLabel.text = [_numberFormatter stringFromScore:answers];
	}
}

- (void)setTitle:(NSString *)title {
	if (_title != title) {
		_title = title;
		self.questionTextLabel.text = title;
	}
}

// KVO method for updating the tag view on change of the public property
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual: @"tags"] && self.tags) {
		[self.tagList reloadData];
	}
}


#pragma mark Object Lifecycle

- (void)configureWithQuestionData:(OPFQuestion *)question {
	NSInteger questionScore = question.score.integerValue;
	self.score = questionScore;
	self.answers = [question.answerCount integerValue];
	self.tags = question.tags;
	self.title = question.title;
	
	self.answersIndicatorImageView.image = [UIImage opf_postStatusImageForScore:questionScore hasAcceptedAnswer:(question.acceptedAnswerId != nil)];
	
	UIImage *metadataBackgroundImage = nil;
	if (questionScore > 100) {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-accepted-background@2x"];
	} else if (questionScore > 25) {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-cool-background@2x"];
	} else if (questionScore < -5) {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-horrible-background@2x"];
	} else if (questionScore < 0) {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-bad-background@2x"];
	} else {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-normal-background@2x"];
	}
	self.metadataBackgroundImageView.image = metadataBackgroundImage;
	
	CGSize selfSize = self.bounds.size;
	CGSize metadataSize = self.metadataBackgroundImageView.bounds.size;
	CGSize questionTextLabelBoundingSize = CGSizeMake(selfSize.width - metadataSize.width - 20, selfSize.height - 10);
	CGSize questionTextLabelSize = [self.questionTextLabel sizeThatFits:questionTextLabelBoundingSize];
	CGRect questionTextLabelFrame = self.questionTextLabel.frame;
	questionTextLabelFrame.size = questionTextLabelSize;
	self.questionTextLabel.frame = questionTextLabelFrame;
}

- (void)sharedSingleQuestionPreviewCellInit
{
	_numberFormatter = OPFScoreNumberFormatter.new;
	
	UIView *backgroundView = UIView.new;
	backgroundView.backgroundColor = UIColor.whiteColor;
	self.backgroundView = backgroundView;
	
	[self addObserver:self forKeyPath:@"tags" options:0 context:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) [self sharedSingleQuestionPreviewCellInit];
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) [self sharedSingleQuestionPreviewCellInit];
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.tagList.dataSource = self;
	self.tagList.delegate = self;
	
	CGFloat textShadowOpacity = .7f;
	CGFloat textShadowRadius = 1.f;
	CGSize textShadowOffset = CGSizeMake(0, 1.f);
	self.scoreLabel.layer.shadowColor = UIColor.blackColor.CGColor;
	self.scoreLabel.layer.shadowOffset = textShadowOffset;
	self.scoreLabel.layer.shadowRadius = textShadowRadius;
	self.scoreLabel.layer.shadowOpacity = textShadowOpacity;
	self.answersLabel.layer.shadowColor = UIColor.blackColor.CGColor;
	self.answersLabel.layer.shadowOffset = textShadowOffset;
	self.answersLabel.layer.shadowRadius = textShadowRadius;
	self.answersLabel.layer.shadowOpacity = textShadowOpacity;
}

- (void)prepareForReuse
{
	self.delegate = nil;
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


#pragma mark - CGTagListDelegate
- (void)tagList:(GCTagList *)taglist didSelectedLabelAtIndex:(NSInteger)idx
{
	if ([self.delegate respondsToSelector:@selector(singleQuestionPreviewCell:didSelectTag:)]) {
		NSString *tag = self.tags[idx];
		[self.delegate singleQuestionPreviewCell:self didSelectTag:tag];
	}
}



@end
