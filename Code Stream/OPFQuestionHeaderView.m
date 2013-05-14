//
//  OPFQuestionHeaderView.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionHeaderView.h"
#import "OPFQuestion.h"
#import "OPFScoreNumberFormatter.h"
#import "UIImage+OPFScalingAndResizing.h"
#import <QuartzCore/QuartzCore.h>
#import <SSLineView.h>


@interface OPFQuestionHeaderView (/*Private*/)
@property (strong, nonatomic) OPFScoreNumberFormatter *scoreFormatter;

@property (assign, nonatomic) NSInteger questionScore;
@property (assign, nonatomic) BOOL hasAcceptedAnswer;

@property (strong, nonatomic) SSLineView *topBorderView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *metadataBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *metadataAcceptedAnswerImageView;
@end


@implementation OPFQuestionHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_scoreFormatter = OPFScoreNumberFormatter.new;
		_questionScore = 0;
		_backgroundImageView = [[UIImageView alloc] init];
		self.backgroundColor = UIColor.clearColor;
		
		self.layer.shadowColor = UIColor.blackColor.CGColor;
		self.layer.shadowOffset = CGSizeMake(0.f, 0.f);
		self.layer.shadowRadius = 6.f;
		self.layer.shadowOpacity = .25f;
		
		self.layer.masksToBounds = NO;
		self.clipsToBounds = NO;
		
		SSLineView *topBorderView = [[SSLineView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 2.f)];
		topBorderView.lineColor = [UIColor colorWithWhite:0.f alpha:.45f];
		topBorderView.insetColor = [UIColor colorWithWhite:1.f alpha:.3f];
		topBorderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_topBorderView = topBorderView;
		[self addSubview:_topBorderView];
	}
	return self;
}

- (void)configureForQuestion:(OPFQuestion *)question
{
	NSParameterAssert([question isKindOfClass:OPFQuestion.class]);
	
	NSInteger score = question.score.integerValue;
	self.questionScore = score;
	self.hasAcceptedAnswer = question.acceptedAnswerId != nil;
	
	self.textLabel.text = question.title;
	self.scoreLabel.text = [self.scoreFormatter stringFromScore:score];
	
	[self updateBackgroundViewForScore];
	[self updateMetadataForScoreAndAccptedAnswer];
	
	[self setNeedsDisplay];
	[self setNeedsLayout];
}

- (void)updateBackgroundViewForScore
{
	UIImage *backgroundImage = nil;
	if (self.questionScore > 100) {
		backgroundImage = [UIImage opf_resizableImageNamed:@"question-header-accepted-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	} else if (self.questionScore > 25) {
		backgroundImage = [UIImage opf_resizableImageNamed:@"question-header-cool-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	} else if (self.questionScore < -5) {
		backgroundImage = [UIImage opf_resizableImageNamed:@"question-header-horrible-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	} else if (self.questionScore < 0) {
		backgroundImage = [UIImage opf_resizableImageNamed:@"question-header-bad-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	} else {
		backgroundImage = [UIImage opf_resizableImageNamed:@"question-header-normal-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	}
	
	self.backgroundImageView.image = backgroundImage;
	self.backgroundView = self.backgroundImageView;
	[self setNeedsLayout];
}

- (void)updateMetadataForScoreAndAccptedAnswer
{
	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGPathRef shadowPath = CGPathCreateWithRect(self.bounds, NULL);
	self.layer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
	
	CGRect topBorderViewFrame = self.topBorderView.frame;
	topBorderViewFrame.size.width = CGRectGetWidth(self.bounds);
	self.topBorderView.frame = topBorderViewFrame;
}

@end
