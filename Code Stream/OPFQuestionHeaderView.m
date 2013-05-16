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
#import "UIImage+OPFScoreImages.h"
#import "UIFont+OPFAppFonts.h"
#import <QuartzCore/QuartzCore.h>
#import <SSLineView.h>


@interface OPFQuestionHeaderView (/*Private*/)
@property (strong, nonatomic) OPFScoreNumberFormatter *scoreFormatter;

@property (assign, nonatomic) NSInteger questionScore;
@property (assign, nonatomic) BOOL hasAcceptedAnswer;

@property (strong, nonatomic) SSLineView *topBorderView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *metadataBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *metadataAnswerStatusImageView;
@end


@implementation OPFQuestionHeaderView

static const CGFloat kMetadataPaddingRight = 10.f;
static const CGFloat kMetadataPaddingLeft = 10.f;
static const CGFloat kMetadataMargin = 6.f;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_scoreFormatter = OPFScoreNumberFormatter.new;
		_questionScore = 0;
		_backgroundImageView = [[UIImageView alloc] init];
		
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

- (void)awakeFromNib
{
	self.metadataBackgroundImageView.image = [UIImage opf_resizableImageNamed:@"question-score-background" withCapInsets:UIEdgeInsetsMake(8.f, 16.f, 8.f, 0.f) resizingMode:UIImageResizingModeTile];
	
	[self applyPropertiesOnLabel:self.titleLabel];
	self.titleLabel.font = [UIFont opf_boldAppFontOfSize:16.f];
	[self applyPropertiesOnLabel:self.scoreLabel];
	self.scoreLabel.font = [UIFont opf_boldAppFontOfSize:15.f];
}

- (void)configureForQuestion:(OPFQuestion *)question
{
	NSParameterAssert([question isKindOfClass:OPFQuestion.class]);
	
	NSInteger score = question.score.integerValue;
	self.questionScore = score;
	self.hasAcceptedAnswer = question.acceptedAnswerId != nil;
	
	self.titleLabel.text = question.title;
	self.scoreLabel.text = [self.scoreFormatter stringFromScore:score];
	
	[self updateBackgroundViewForScore];
	[self updateMetadataForScoreAndAccptedAnswer];
	
	[self setNeedsDisplay];
	[self setNeedsLayout];
}

- (void)applyShadowToView:(UIView *)view
{
	view.layer.shadowColor = UIColor.blackColor.CGColor;
	view.layer.shadowOffset = CGSizeMake(0, 1);
	view.layer.shadowRadius = 1;
	view.layer.shadowOpacity = .75f;
}

- (void)applyPropertiesOnLabel:(UILabel *)label
{
	[self applyShadowToView:label];
	label.textColor = UIColor.whiteColor;
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
	self.metadataAnswerStatusImageView.image = [UIImage opf_postStatusImageForScore:1000 hasAcceptedAnswer:self.hasAcceptedAnswer];
	
	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	CGFloat width = CGRectGetWidth(bounds);
	
	CGPathRef shadowPath = CGPathCreateWithRect(self.bounds, NULL);
	self.layer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
	
	CGRect topBorderViewFrame = self.topBorderView.frame;
	topBorderViewFrame.size.width = CGRectGetWidth(self.bounds);
	self.topBorderView.frame = topBorderViewFrame;
	
	CGRect statusFrame = self.metadataAnswerStatusImageView.frame;
	CGFloat statusSize = 20.f;
	CGFloat statusOriginX = width - (statusSize + kMetadataPaddingRight);
	statusFrame.size = CGSizeMake(statusSize, statusSize);
	statusFrame.origin.x = statusOriginX;
	self.metadataAnswerStatusImageView.frame = statusFrame;
	
	[self.scoreLabel sizeToFit];
	CGRect scoreFrame = self.scoreLabel.frame;
	CGFloat scoreWidth = CGRectGetWidth(scoreFrame);
	scoreFrame.origin.x = statusOriginX - (scoreWidth + kMetadataMargin);
	scoreFrame.origin.y = CGRectGetMidY(bounds) - CGRectGetHeight(scoreFrame) / 2;
	self.scoreLabel.frame = CGRectIntegral(scoreFrame);
	
	CGRect metadataBackgroundFrame = self.metadataBackgroundImageView.frame;
	CGFloat metadataBackgroundWidth = kMetadataPaddingLeft + scoreWidth + kMetadataMargin + statusSize + kMetadataPaddingRight;
	CGFloat metadataBackgroundOriginX = width - metadataBackgroundWidth;
	metadataBackgroundFrame.size.width = metadataBackgroundWidth;
	metadataBackgroundFrame.origin.x = metadataBackgroundOriginX;
	self.metadataBackgroundImageView.frame = metadataBackgroundFrame;
}

@end
