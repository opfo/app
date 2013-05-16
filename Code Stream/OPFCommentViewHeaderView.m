//
//  OPFCommentViewHeader.m
//  Code Stream
//
//  Created by Tobias Deekens on 17.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFCommentViewHeaderView.h"
#import "UIView+OPFViewLoading.h"
#import "OPFPost.h"
#import "OPFAnswer.h"
#import "UIImageView+KHGravatar.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+OPFScalingAndResizing.h"
#import "UIFont+OPFAppFonts.h"
#import <QuartzCore/QuartzCore.h>
#import <SSLineView.h>

@interface OPFCommentViewHeaderView()

@property (assign, nonatomic) NSInteger postScore;
@property (strong, nonatomic) OPFPost *postModel;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) SSLineView *topBorderView;

@property (weak, nonatomic) IBOutlet UIImageView *metadataBackgroundImageView;

- (void)loadUserGravatar;

@end

@implementation OPFCommentViewHeaderView

static NSString *const NoCountInformationPlaceholder = @"0";
static CGFloat const LabelOpacity = .7f;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
        _postScore = 0;
		_dateFormatter = NSDateFormatter.new;
        [_dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
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
	self.metadataBackgroundImageView.image = [UIImage opf_resizableImageNamed:@"comment-count-background" withCapInsets:UIEdgeInsetsMake(8.f, 16.f, 8.f, 0.f) resizingMode:UIImageResizingModeTile];
	
	[self applyPropertiesOnLabel:self.postTitle];
	self.postTitle.font = [UIFont opf_boldAppFontOfSize:16.f];
	[self applyPropertiesOnLabel:self.postCommentCount];
	self.postCommentCount.font = [UIFont opf_boldAppFontOfSize:15.f];
}

- (void)configureForPost:(OPFPost *)post
{
	NSParameterAssert([post isKindOfClass:OPFPost.class]);
    
    self.postModel = post;
	
    self.postScore = self.postModel.score.integerValue;
    
    NSString *title = (! [self.postModel.title isEqualToString:@"NULL"] ) ? self.postModel.title : ((OPFAnswer *) self.postModel).parent.title;
    
	self.postTitle.text = title;
    self.postUserName.text = self.postModel.owner.displayName;
    self.postDate.text = [self.dateFormatter stringFromDate:self.postModel.creationDate];
    self.postCommentCount.text = [NSString stringWithFormat:@"%ld", (long)self.postModel.commentCount.integerValue];
    
    self.postUserName.textColor = [UIColor colorWithWhite:1.0f alpha:LabelOpacity];
    self.postDate.textColor = [UIColor colorWithWhite:1.0f alpha:LabelOpacity];
    
    [self loadUserGravatar];
    
	[self updateBackgroundView];
	[self updateMetadataForCommentCount];
	
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

- (void)updateBackgroundView
{
	UIImage *backgroundImage = nil;
    
	if (self.postScore > 100) {
		backgroundImage = [UIImage opf_resizableImageNamed:@"comment-header-accepted-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	} else if (self.postScore > 25) {
		backgroundImage = [UIImage opf_resizableImageNamed:@"comment-header-cool-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	} else if (self.postScore < -5) {
		backgroundImage = [UIImage opf_resizableImageNamed:@"comment-header-horrible-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	} else if (self.postScore < 0) {
		backgroundImage = [UIImage opf_resizableImageNamed:@"comment-header-bad-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	} else {
		backgroundImage = [UIImage opf_resizableImageNamed:@"comment-header-normal-background" withCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	}
	
	self.backgroundImageView.image = backgroundImage;
	self.backgroundView = self.backgroundImageView;
	[self setNeedsLayout];
}

- (void)updateMetadataForCommentCount
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

- (void)loadUserGravatar
{
    __weak OPFCommentViewHeaderView *weakSelf = self;
    
    [self.userAvatar setImageWithGravatarEmailHash:self.postModel.owner.emailHash
                                  placeholderImage:weakSelf.userAvatar.image
                                  defaultImageType:KHGravatarDefaultImageMysteryMan
                                            rating:KHGravatarRatingX
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               self.userAvatar.image = image;
                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               
                                           }];
}

@end
