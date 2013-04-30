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

#pragma mark - Reuse Identifiers
static NSString *const BodyCellIdentifier = @"PostBodyCell";
static NSString *const MetadataCellIdentifier = @"PostMetadataCell";
static NSString *const TagsCellIdentifier = @"PostTagsCell";
static NSString *const CommentsCellIdentifier = @"PostCommentsCell";

static NSString *const QuestionHeaderViewIdentifier = @"QuestionHeaderView";

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
	
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFPostBodyTableViewCell) bundle:nil] forCellReuseIdentifier:BodyCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFPostMetadataTableViewCell) bundle:nil] forCellReuseIdentifier:MetadataCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFPostTagsTableViewCell) bundle:nil] forCellReuseIdentifier:TagsCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:@"OPFPostCommentTableViewCell" bundle:nil] forCellReuseIdentifier:CommentsCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFQuestionHeaderView) bundle:nil] forHeaderFooterViewReuseIdentifier:QuestionHeaderViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    OPFUser *user = [[OPFUser alloc] init];
    [user setReputation:@(351)];
    [user setDisplayName:@"Aron"];
    OPFPost *post = [[OPFPost alloc] init];
    [post setScore:@(123)];
    [post setTitle:@"This is the question right? Well the title will most likely be a bit long."];
    [post setBody:@"<p>We can write</p>\n\n<pre class=\"\"lang-rb prettyprint-override\"\"><code>get '/foo' do\n  ...\nend\n</code></pre>\n\n<p>and</p>\n\n<pre class=\"\"lang-rb prettyprint-override\"\"><code>post '/foo' do\n  ...\nend\n</code></pre>\n\n<p>which is fine.  But can I combine multiple HTTP verbs in one route?</p>\n"];
	
    post.owner = user;
    
    OPFPost *post1 = [[OPFPost alloc] init];
    [post1 setScore:@(456)];
    [post1 setTitle:@"This is a question with a rather long title, right? But it could also be even longer, or could it? What happens when we make it crazy long?"];
    [post1 setBody:@"<p>Response generated by ASP Webservice:</p>\n\n<pre><code>&lt;?xml version=""1.0"" encoding=""utf-8""?&gt;\n&lt;soap:Envelope xmlns:soap=""http://www.w3.org/2003/05/soap-envelope"" xmlns:rpc=""http://www.w3.org/2003/05/soap-rpc"" xmlns:soapenc=""http://www.w3.org/2003/05/soap-encoding"" xmlns:tns=""http://tempuri.org/"" xmlns:types=""http://tempuri.org/"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""&gt;\n    &lt;soap:Body&gt;\n        &lt;types:GenerateRandomResponse&gt;\n            &lt;rpc:result&gt;GenerateRandomResult&lt;/rpc:result&gt;\n            &lt;GenerateRandomResult xsi:type=""xsd:string""&gt;5kHKi1&lt;/GenerateRandomResult&gt;\n        &lt;/types:GenerateRandomResponse&gt;\n    &lt;/soap:Body&gt;\n&lt;/soap:Envelope&gt;\n</code></pre>\n\n<p>Request in spring:</p>\n\n<pre class=""lang-java prettyprint-override""><code>GenerateRandom generateRandom = new GenerateRandom();\nGenerateRandomResponse response = (GenerateRandomResponse)webServiceTemplate.marshalSendAndReceive(generateRandom);\n</code></pre>\n\n<pre class=""lang-java prettyprint-override""><code>@XmlRootElement(namespace = ""http://tempuri.org/"", name = ""GenerateRandom"")\npublic class GenerateRandom\n{\n}\n</code></pre>\n\n<pre class=""lang-java prettyprint-override""><code>@XmlRootElement(namespace = ""http://tempuri.org/"", name = ""GenerateRandomResponse"")\npublic class GenerateRandomResponse\n{\n}\n</code></pre>\n\n<p>How to bind response to GenerateRandomResponse?\nI try @XmlValue, nothing...</p>\n"];
    
    post1.owner=user;
	
	// If a question was set, load it. Otherwise take this just created mockup question
	if (self.question) {
		[self.posts addObject:self.question];
		[self.posts addObjectsFromArray:self.question.answers];
	} else
		[self.posts addObjectsFromArray:@[ post, post1 ]];
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
	return self.posts[indexPath.section];
}

- (BOOL)isPostQuestionPost:(OPFPost *)post
{
	return post == self.questionPost;
}


#pragma mark -
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	OPFQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:QuestionHeaderViewIdentifier];
	
	OPFPost *post = self.posts[section];
	headerView.titleLabel.text = [post isKindOfClass:[OPFQuestion class]] ? post.title : @"";
	
	OPFScoreNumberFormatter *scoreFormatter = self.cache[@"scoreFormatter"];
	if (scoreFormatter == nil) {
		scoreFormatter = [OPFScoreNumberFormatter new];
		self.cache[@"scoreFormatter"] = scoreFormatter;
	}
	headerView.scoreLabel.text = [scoreFormatter stringFromScore:post.score.unsignedIntegerValue];
	
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	
    OPFPost *post = [self postForIndexPath:indexPath];
	
	
	
    if ([cellIdentifier isEqualToString:BodyCellIdentifier]) {
		((OPFPostBodyTableViewCell*)cell).htmlString = post.body;
		
	} else if ([cellIdentifier isEqualToString:MetadataCellIdentifier]) {
		OPFPostMetadataTableViewCell *metadataCell = (OPFPostMetadataTableViewCell *)cell;
		metadataCell.userPreviewButton.user = post.owner;
												   
											   
	} else if ([cellIdentifier isEqualToString:TagsCellIdentifier]) {
		
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	OPFQuestionHeaderView *headerView = (OPFQuestionHeaderView *)view;
	headerView.backgroundView = [UIView new];
	headerView.backgroundView.backgroundColor = UIColor.lightGrayColor;
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
		height = bodySize.height + kOPQuestionBodyInset;
	} else {
		height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
	}
	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self cellIdentifierForIndexPath:indexPath] isEqualToString:CommentsCellIdentifier] == NO)
        return;
    // Selected cell was comment
	
    OPFPost *post = [self postForIndexPath:indexPath];
    OPFCommentsViewController *commentViewController = [OPFCommentsViewController new];
    
    commentViewController.postModel = post;
    
    [self.navigationController pushViewController:commentViewController animated:YES];
}

@end
