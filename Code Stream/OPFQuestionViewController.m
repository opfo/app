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
#import "OPFQuestionHeaderView.h"
#import "NSCache+OPFSubscripting.h"
#import "OPFPost.h"
#import "OPFQuestion.h"
#import "OPFComment.h"
#import "OPFCommentsViewController.h"
#import "OPFScoreNumberFormatter.h"
#import "UIImageView+KHGravatar.h"
#import "UIImageView+AFNetworking.h"
#import "OPFUserPreviewButton.h"
#import "OPFUserProfileViewController.h"
#import "OPFQuestionsViewController.h"
#import "OPFPostAnswerViewController.h"

enum {
	kOPFQuestionBodyCell = 0,
	kOPFQuestionMetadataCell = 1,
	kOPFQuestionTagsCell = 2,
	kOPFQuestionCommentsWithTagsCell = 3,
	kOPFQuestionCommentsWithoutTagsCell = 2,
};

static const NSInteger kOPFQuestionSection = 0;
static const NSInteger kOPFAnswersSeparatorSection = 1;

static const CGFloat kOPFQuestionBodyInset = 20.f;


@interface OPFQuestionViewController ()
@property (strong, readonly) NSCache *cache;

// TEMP (start):
@property (strong, readonly) NSMutableArray *posts;
- (OPFPost *)questionPost;
- (NSArray *)answerPosts;
// TEMP (end)
@end

@implementation OPFQuestionViewController

#pragma mark - Reuse Identifiers
static NSString *const BodyCellIdentifier = @"PostBodyCell";
static NSString *const MetadataCellIdentifier = @"PostMetadataCell";
static NSString *const TagsCellIdentifier = @"PostTagsCell";
static NSString *const CommentsCellIdentifier = @"PostCommentsCell";

static NSString *const QuestionHeaderViewIdentifier = @"QuestionHeaderView";
static NSString *const AnswersSeparatorHeaderView = @"AnswersSeparatorHeaderView";
static NSString *const AnswerHeaderView = @"AnswerHeaderView";

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
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Question", @"Question view controller title");
	
	self.view.backgroundColor = UIColor.clearColor;
	
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFPostBodyTableViewCell) bundle:nil] forCellReuseIdentifier:BodyCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFPostMetadataTableViewCell) bundle:nil] forCellReuseIdentifier:MetadataCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFPostTagsTableViewCell) bundle:nil] forCellReuseIdentifier:TagsCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:@"OPFPostCommentTableViewCell" bundle:nil] forCellReuseIdentifier:CommentsCellIdentifier];
	
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFQuestionHeaderView) bundle:nil] forHeaderFooterViewReuseIdentifier:QuestionHeaderViewIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:@"OPFQuestionAnswersSeparatorView" bundle:nil] forHeaderFooterViewReuseIdentifier:AnswersSeparatorHeaderView];
	[self.tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:AnswerHeaderView];
	
	UIBarButtonItem *composeAnswer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(postNewAnswer:)];
	self.navigationItem.rightBarButtonItem = composeAnswer;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.posts addObject:self.question];
	[self.posts addObjectsFromArray:self.question.answers];
	[self.tableView reloadData];
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
			if (post1.score == post2.score) return NSOrderedSame;
			return (post1.score > post2.score ? NSOrderedDescending : NSOrderedAscending);
		}];
		self.cache[@"answerPosts"] = answerPosts;
	} else {
		answerPosts = NSArray.array;
	}
	
	return answerPosts;
}

- (OPFPost *)postForIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = indexPath.section;
	section = section > kOPFAnswersSeparatorSection ? section - 1 : section;
	return self.posts[section];
}

- (BOOL)isPostQuestionPost:(OPFPost *)post
{
	return post == self.questionPost;
}


#pragma mark -
- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = nil;
	if (indexPath.section == kOPFAnswersSeparatorSection) {
		cellIdentifier = AnswersSeparatorHeaderView;
	} else {
		if (indexPath.row == kOPFQuestionBodyCell) {
			cellIdentifier = BodyCellIdentifier;
		} else if (indexPath.row == kOPFQuestionMetadataCell) {
			cellIdentifier = MetadataCellIdentifier;
		} else {
			if (indexPath.section == kOPFQuestionSection) {
				if (indexPath.row == kOPFQuestionTagsCell) {
					cellIdentifier = TagsCellIdentifier;
				} else if (indexPath.row == kOPFQuestionCommentsWithTagsCell) {
					cellIdentifier = CommentsCellIdentifier;
				}
			} else if (indexPath.row == kOPFQuestionCommentsWithoutTagsCell) {
				cellIdentifier = CommentsCellIdentifier;
			}
		}
	}
	return cellIdentifier;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Each post gets its own section and then we have a section for the
    return self.posts.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// The first section corresponds the question which has an extra row for tags.
	NSInteger rows = 0;
	if (section == kOPFQuestionSection) {
		rows = 4;
	} else if (section == kOPFAnswersSeparatorSection) {
		rows = 0;
	} else {
		rows = 3;
	}
    return rows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *headerView = nil;
	if (section == kOPFQuestionSection) {
		OPFQuestionHeaderView *questionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:QuestionHeaderViewIdentifier];
		
		NSInteger dataIndex = section > kOPFAnswersSeparatorSection ? section - 1 : section;
		OPFQuestion *question = self.posts[dataIndex];
		[questionHeaderView configureForQuestion:question];
		
		headerView = questionHeaderView;
	} else if (section == kOPFAnswersSeparatorSection) {
		headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AnswersSeparatorHeaderView];
	} else {
		headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AnswerHeaderView];
	}
	
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	
    OPFPost *post = [self postForIndexPath:indexPath];
	
    if ([cellIdentifier isEqualToString:BodyCellIdentifier]) {
		((OPFPostBodyTableViewCell*)cell).htmlString = post.body;
        ((OPFPostBodyTableViewCell*)cell).navigationcontroller = self.navigationController;
		
	} else if ([cellIdentifier isEqualToString:MetadataCellIdentifier]) {
		OPFPostMetadataTableViewCell *metadataCell = (OPFPostMetadataTableViewCell *)cell;
		metadataCell.userPreviewButton.iconAlign = Right;
		metadataCell.userPreviewButton.user = post.owner;
		[metadataCell.userPreviewButton addTarget:self action:@selector(pressedUserPreviewButton:) forControlEvents:UIControlEventTouchUpInside];
												   
											   
	} else if ([cellIdentifier isEqualToString:TagsCellIdentifier]) {
		OPFPostTagsTableViewCell *tagsCell = (OPFPostTagsTableViewCell *)cell;
		tagsCell.tags = self.question.tags;
		tagsCell.tagsView.delegate = self;
		tagsCell.tagsView.dataSource = tagsCell;
		[tagsCell.tagsView reloadData];
		
	} else if ([cellIdentifier isEqualToString:CommentsCellIdentifier]) {
		if (post.comments.count > 0) { 
			cell.detailTextLabel.text = ((OPFComment*)post.comments[0]).text;
		} else {
			cell.detailTextLabel.text = NSLocalizedString(@"Add the first comment", @"No comments on post summary label.");
		}
	} else {
		NSAssert(NO, @"Unknonw cell identifier '%@'", cellIdentifier);
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = UIColor.whiteColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0.f;
	if (indexPath.row == kOPFQuestionBodyCell) {
		OPFPost *post = [self postForIndexPath:indexPath];
		NSString *body = post.body;
	
		UIFont *bodyFont = [UIFont systemFontOfSize:14.f];
		CGSize constrainmentSize = CGSizeMake(CGRectGetWidth(tableView.bounds), 99999999.f);
		CGSize bodySize = [body sizeWithFont:bodyFont constrainedToSize:constrainmentSize lineBreakMode:NSLineBreakByWordWrapping];
		height = bodySize.height + kOPFQuestionBodyInset;
	} else {
		height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
	}
	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	CGFloat height = 44.f;
	if (section == kOPFQuestionSection) {
		height = 45.f;
	} else if (section == kOPFAnswersSeparatorSection) {
		height = 22.f;
	}
	return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[self cellIdentifierForIndexPath:indexPath] isEqualToString:MetadataCellIdentifier]) {
		OPFPost *post = [self postForIndexPath:indexPath];
		OPFUserProfileViewController *view = OPFUserProfileViewController.newFromStoryboard;
		view.user = post.owner;
		
		[self.navigationController pushViewController:view animated:YES];
		
	}
    if ([[self cellIdentifierForIndexPath:indexPath] isEqualToString:CommentsCellIdentifier]) {
        
		// Selected cell was comment
		
		OPFPost *post = [self postForIndexPath:indexPath];
		OPFCommentsViewController *commentViewController = [OPFCommentsViewController new];
		
		commentViewController.postModel = post;
		
		[self.navigationController pushViewController:commentViewController animated:YES];
	}
}

#pragma mark - User Preview Button delegate
- (void)pressedUserPreviewButton:(id)sender {
	OPFUserProfileViewController *userProfileViewController = OPFUserProfileViewController.newFromStoryboard;
    userProfileViewController.user = ((OPFUserPreviewButton*)sender).user;
    
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

#pragma mark - Tag List Delegate

- (void)tagList:(GCTagList *)taglist didSelectedLabelAtIndex:(NSInteger)index {
	
	
	
	int views = self.navigationController.viewControllers.count;
	
	// See if the previous view controller was a questionS view
	Boolean reuse = (views >= 1) && [self.navigationController.viewControllers[views-2] isKindOfClass:[OPFQuestionsViewController class]];
	
	// Reuse the questionS view if available. Otherwise create new view
	OPFQuestionsViewController *view = (reuse) ? self.navigationController.viewControllers[views-2] :[OPFQuestionsViewController new] ;
	
	// Add search string to view
	view.searchString = [NSString stringWithFormat:@"[%@]", [taglist.dataSource tagList:taglist tagLabelAtIndex:index].text];
	
	
	
	// Navigate to the view
	if (reuse)
		[self.navigationController popViewControllerAnimated:YES];
	else
		[self.navigationController pushViewController:view animated:YES];
	
}

#pragma mark - Post a new answer
-(void) postNewAnswer:(id) sender{
    OPFPostAnswerViewController *postview = [OPFPostAnswerViewController new];
    postview.title = @"Post a question";
    postview.parentQuestion = [self.question.identifier integerValue];
    [self.navigationController pushViewController:postview animated:YES];
    [self reloadInputViews];
}






@end
