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
#import "NSString+OPFStripCharacters.h"
#import <QuartzCore/QuartzCore.h>


@implementation OPFSingleQuestionPreviewCell {
	OPFScoreNumberFormatter *_numberFormatter;
}

#pragma mark Object Lifecycle
- (void)configureWithQuestionData:(OPFQuestion *)question
{
	NSInteger questionScore = question.score.integerValue;
	self.scoreLabel.text = [_numberFormatter stringFromScore:questionScore];
	self.answersLabel.text = [_numberFormatter stringFromScore:question.answerCount.integerValue];
	
	self.answersIndicatorImageView.image = [UIImage opf_postStatusImageForScore:questionScore hasAcceptedAnswer:(question.acceptedAnswerId != nil)];
	
	UIImage *metadataBackgroundImage = nil;
	if (questionScore > 100) {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-accepted-background"];
	} else if (questionScore > 25) {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-cool-background"];
	} else if (questionScore < -5) {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-horrible-background"];
	} else if (questionScore < 0) {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-bad-background"];
	} else {
		metadataBackgroundImage = [UIImage imageNamed:@"question-row-metadata-normal-background"];
	}
	self.metadataBackgroundImageView.image = metadataBackgroundImage;
	
	NSAttributedString *questionText = [self attributedTextForQuestion:question];
	self.questionTextLabel.attributedText = questionText;
	
	CGSize selfSize = self.bounds.size;
	CGSize metadataSize = self.metadataBackgroundImageView.bounds.size;
	CGSize questionTextLabelBoundingSize = CGSizeMake(selfSize.width - metadataSize.width - 20, selfSize.height - 10);
	CGSize questionTextLabelSize = [self.questionTextLabel sizeThatFits:questionTextLabelBoundingSize];
	CGRect questionTextLabelFrame = self.questionTextLabel.frame;
	questionTextLabelFrame.size = questionTextLabelSize;
	self.questionTextLabel.frame = questionTextLabelFrame;
	
	[self.questionTextLabel setNeedsDisplay];
}

- (NSAttributedString *)attributedTextForQuestion:(OPFQuestion *)question
{
	NSDictionary *questionTitleAttributes = @{
		NSFontAttributeName: [UIFont opf_boldAppFontOfSize:15.f],
		NSForegroundColorAttributeName: UIColor.blackColor,
		NSParagraphStyleAttributeName: NSParagraphStyle.defaultParagraphStyle
	};
	NSAttributedString *questionTitleString = [[NSAttributedString alloc] initWithString:question.title attributes:questionTitleAttributes];
	
	// Body text disabled at the moment as we would need to strip every single
	// peice of HTML/Markdown/whatnot from it before showing it. Ain’t nobody
	// got time for that!
//	NSMutableParagraphStyle *bodyParagraphStyle = [[NSMutableParagraphStyle alloc] init];
//	bodyParagraphStyle.alignment = NSTextAlignmentLeft;
//	bodyParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//	NSDictionary *questionBodyAttributes = @{
//		NSFontAttributeName: [UIFont opf_appFontOfSize:15.f],
//		NSForegroundColorAttributeName: UIColor.darkGrayColor,
//		NSParagraphStyleAttributeName: bodyParagraphStyle
//	};
//	NSString *body = question.body.opf_stringByStrippingHTML.opf_stringByTrimmingWhitespace.opf_stringByStrippingNewlines;
//	NSAttributedString *questionBodyString = [[NSAttributedString alloc] initWithString:[@"\n" stringByAppendingString:body] attributes:questionBodyAttributes];
	
	NSMutableAttributedString *questionText = [[NSMutableAttributedString alloc] init];
	[questionText appendAttributedString:questionTitleString];
//	[questionText appendAttributedString:questionBodyString];
	
	return questionText;
}

- (void)sharedSingleQuestionPreviewCellInit
{
	_numberFormatter = OPFScoreNumberFormatter.new;
	
	UIView *backgroundView = UIView.new;
	backgroundView.backgroundColor = UIColor.whiteColor;
	self.backgroundView = backgroundView;
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
	
	self.questionTextLabel.highlightedTextColor = UIColor.whiteColor;
}

- (void)prepareForReuse
{
	self.delegate = nil;
}

- (UILabel *)textLabel
{
	return self.questionTextLabel;
}



@end
