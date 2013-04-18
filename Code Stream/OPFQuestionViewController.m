//
//  OPFQuestionViewController.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 16-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFQuestionViewController.h"
#import "OPFPostBodyTableViewCell.h"
#import "OPFPostMetadataTableViewCell.h"
#import "OPFPostTagsTableViewCell.h"
#import "NSCache+OPFSubscripting.h"

enum {
	kOPFQuestionBodyCell = 0,
	kOPFQuestionMetadataCell = 1,
	kOPFQuestionTagsCell = 2,
	kOPFQuestionCommentsWithTagsCell = 3,
	kOPFQuestionCommentsWithoutTagsCell = 2,
};

static const NSInteger kOPQuestionSection = 0;

static const CGFloat kOPQuestionBodyInset = 20.f;


@interface OPFQuestionViewController ()
@property (strong, readonly) NSCache *cache;

// TEMP (start):
@property (strong, readonly) NSMutableArray *posts;
- (OPFPost *)questionPost;
- (NSArray *)answerPosts;
// TEMP (end)
@end

@implementation OPFQuestionViewController

#pragma mark - Object Lifecycle
- (void)questionViewControllerSharedInit
{
	_posts = [[NSMutableArray alloc] init];
}

- (id)init
{
	self = [super init];
	if (self) {
		[self questionViewControllerSharedInit];
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		[self questionViewControllerSharedInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self questionViewControllerSharedInit];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self questionViewControllerSharedInit];
	}
	return self;
}


#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
	[self.posts addObjectsFromArray:@[ @"First", @"Second", @"Third" ]];
	
	[super viewWillAppear:animated];
}


#pragma mark - 
- (OPFPost *)questionPost
{
	return self.posts.count > 0 ? self.posts[0] : nil;
}

- (NSArray *)answerPosts
{
	NSArray *answerPosts = self.cache[@"answerPosts"];
	// Posts count must be larger than one (1) as the first post (index 0) is
	// the question post.
	if (answerPosts == nil && self.posts.count > 1) {
		answerPosts = [self.posts sortedArrayUsingComparator:^NSComparisonResult(OPFPost *post1, OPFPost *post2) {
			return NSOrderedSame;
//			if (post1.score == post2.score) return NSOrderedSame;
//			return (post1.score > post2.score ? NSOrderedDescending : NSOrderedAscending);
		}];
		self.cache[@"answerPosts"] = answerPosts;
	} else {
		answerPosts = NSArray.array;
	}
	
	return answerPosts;
}

- (OPFPost *)postForIndexPath:(NSIndexPath *)indexPath
{
	return self.posts[indexPath.section];
}

- (BOOL)isPostQuestionPost:(OPFPost *)post
{
	return post == self.questionPost;
}


#pragma mark -
static NSString *BodyCellIdentifier = @"PostBodyCell";
static NSString *MetadataCellIdentifier = @"PostMetadataCell";
static NSString *TagsCellIdentifier = @"PostTagsCell";
static NSString *CommentsCellIdentifier = @"PostCommentsCell";

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = nil;
	if (indexPath.row == kOPFQuestionBodyCell) {
		cellIdentifier = BodyCellIdentifier;
	} else if (indexPath.row == kOPFQuestionMetadataCell) {
		cellIdentifier = MetadataCellIdentifier;
	} else {
		if (indexPath.section == kOPQuestionSection) {
			if (indexPath.row == kOPFQuestionTagsCell) {
				cellIdentifier = TagsCellIdentifier;
			} else if (indexPath.row == kOPFQuestionCommentsWithTagsCell) {
				cellIdentifier = CommentsCellIdentifier;
			}
		} else if (indexPath.row == kOPFQuestionCommentsWithoutTagsCell) {
			cellIdentifier = CommentsCellIdentifier;
		}
	}
	return cellIdentifier;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.posts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// The first section corresponds the question which has an extra row for tags.
    return (section == 0 ? 4 : 3);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Some post header";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	
	if ([cellIdentifier isEqualToString:BodyCellIdentifier]) {
		((OPFPostBodyTableViewCell *)cell).bodyTextView.text = @"Some nice test text Some nice test text Some nice test text Some nice test text Some nice test text Some nice test text Some nice test text Some nice test text ";
	} else if ([cellIdentifier isEqualToString:MetadataCellIdentifier]) {
		OPFPostMetadataTableViewCell *metadataCell = (OPFPostMetadataTableViewCell *)cell;
		metadataCell.authorLabel.text = @"Aron";
		metadataCell.authorScoreLabel.text = @"351 points";
	} else if ([cellIdentifier isEqualToString:TagsCellIdentifier]) {
	} else if ([cellIdentifier isEqualToString:CommentsCellIdentifier]) {
		cell.textLabel.text = NSLocalizedString(@"No comments, yet…", @"No comments on post label.");
	} else {
		NSAssert(NO, @"Unknonw cell identifier '%@'", cellIdentifier);
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0.f;
	if (indexPath.row == kOPFQuestionBodyCell) {
		OPFPost *post = [self postForIndexPath:indexPath];
		NSString *body = @"Some nice test text Some nice test text Some nice test text Some nice test text Some nice test text Some nice test text Some nice test text Some nice test text ";//post.body;
	
		UIFont *bodyFont = [UIFont systemFontOfSize:14.f];
		CGSize constrainmentSize = CGSizeMake(CGRectGetWidth(tableView.bounds), 99999999.f);
		CGSize bodySize = [body sizeWithFont:bodyFont constrainedToSize:constrainmentSize lineBreakMode:NSLineBreakByWordWrapping];
		height = bodySize.height + kOPQuestionBodyInset;
	} else {
		height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
	}
	return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
