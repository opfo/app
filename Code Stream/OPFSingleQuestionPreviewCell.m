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


@interface OPFSingleQuestionPreviewCell (/*Private*/)
@property (strong, nonatomic) NSAttributedString *questionTextLabelText;
@property (strong, nonatomic) NSAttributedString *highlightedQuestionTextLabelText;
@end


@implementation OPFSingleQuestionPreviewCell {
	OPFScoreNumberFormatter *_numberFormatter;
}

#pragma mark Object Lifecycle
- (void)configureWithQuestionData:(OPFQuestion *)question
{
	NSParameterAssert(question != nil);
	
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
	
	NSString *questionTitle = question.title.opf_stringByStrippingHTML.opf_stringByTrimmingWhitespace;
	NSString *questionBody = question.body.opf_stringByStrippingHTML.opf_stringByTrimmingWhitespace;
	NSUInteger questionBodyToIndex = questionBody.length < 200 ? questionBody.length - 1 : 200;
	questionBody = [questionBody substringToIndex:questionBodyToIndex];
	self.questionTextLabelText = [self attributedTextForQuestionTitle:questionTitle questionBody:questionBody highlighted:NO];
	self.highlightedQuestionTextLabelText = [self attributedTextForQuestionTitle:questionTitle questionBody:questionBody highlighted:YES];
	
	[self updateQuestionTextLabelForHightlightState:(self.highlighted || self.selected)];
}


#pragma mark - Layout and Drawing
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize selfSize = self.bounds.size;
	CGSize metadataSize = self.metadataBackgroundImageView.bounds.size;
	CGSize questionTextLabelBoundingSize = CGSizeMake(selfSize.width - metadataSize.width - 20, selfSize.height - 10);
	CGSize questionTextLabelSize = [self.questionTextLabel sizeThatFits:questionTextLabelBoundingSize];
	CGRect questionTextLabelFrame = self.questionTextLabel.frame;
	questionTextLabelFrame.size = questionTextLabelSize;
	self.questionTextLabel.frame = questionTextLabelFrame;
}


#pragma mark - Object Lifecycle
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
}

- (void)prepareForReuse
{
	self.delegate = nil;
}


#pragma mark - Highlight State
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[self updateQuestionTextLabelForHightlightState:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	[self updateQuestionTextLabelForHightlightState:selected];
}

- (void)updateQuestionTextLabelForHightlightState:(BOOL)highlight
{
	self.questionTextLabel.attributedText = (highlight ? self.highlightedQuestionTextLabelText : self.questionTextLabelText);
}


#pragma mark - Question Label Text
- (NSAttributedString *)attributedTextForQuestionTitle:(NSString *)questionTitle questionBody:(NSString *)questionBody highlighted:(BOOL)highlighted
{
	NSParameterAssert(questionTitle != nil);
	questionBody = questionBody ?: @"";

	NSDictionary *questionTitleAttributes = (highlighted == NO ? self.class.questionTitleAttributes : self.class.highlightedQuestionTitleAttributes);
	NSAttributedString *questionTitleString = [[NSAttributedString alloc] initWithString:questionTitle attributes:questionTitleAttributes];

	// Body text disabled at the moment as we would need to strip every single
	// peice of HTML/Markdown/whatnot from it before showing it. Ain’t nobody
	// got time for that!
	NSDictionary *questionBodyAttributes = (highlighted == NO ? self.class.questionBodyAttributes : self.class.highlightedQuestionBodyAttributes);
	NSString *body = questionBody.opf_stringByStrippingHTML.opf_stringByTrimmingWhitespace;
	NSAttributedString *questionBodyString = [[NSAttributedString alloc] initWithString:[@"\n" stringByAppendingString:body] attributes:questionBodyAttributes];

	NSMutableAttributedString *questionText = [[NSMutableAttributedString alloc] init];
	[questionText appendAttributedString:questionTitleString];
	[questionText appendAttributedString:questionBodyString];

	return questionText;
}


#pragma mark - Question Label Attributes
+ (NSDictionary *)questionTitleAttributes
{
	static NSDictionary *attributes = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		attributes = @{
			NSFontAttributeName: [UIFont opf_boldAppFontOfSize:15.f],
			NSForegroundColorAttributeName: UIColor.blackColor,
			NSParagraphStyleAttributeName: NSParagraphStyle.defaultParagraphStyle
		};
	});
	return attributes;
}

+ (NSDictionary *)highlightedQuestionTitleAttributes
{
	static NSDictionary *attributes = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *questionTitleAttributes = self.questionTitleAttributes.mutableCopy;
		questionTitleAttributes[NSForegroundColorAttributeName] = UIColor.whiteColor;
		attributes = questionTitleAttributes.copy;
	});
	return attributes;
}

+ (NSDictionary *)questionBodyAttributes
{
	static NSDictionary *attributes = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableParagraphStyle *bodyParagraphStyle = [[NSMutableParagraphStyle alloc] init];
		bodyParagraphStyle.alignment = NSTextAlignmentLeft;
		bodyParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
		
		attributes = @{
			NSFontAttributeName: [UIFont opf_appFontOfSize:15.f],
			NSForegroundColorAttributeName: UIColor.darkGrayColor,
			NSParagraphStyleAttributeName: bodyParagraphStyle
		};
	});
	return attributes;
}

+ (NSDictionary *)highlightedQuestionBodyAttributes
{
	static NSDictionary *attributes = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *questionBodyAttributes = self.questionBodyAttributes.mutableCopy;
		questionBodyAttributes[NSForegroundColorAttributeName] = UIColor.whiteColor;
		attributes = questionBodyAttributes.copy;
	});
	return attributes;
}


@end
