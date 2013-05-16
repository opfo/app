//
//  OPFCommentViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFCommentsViewController.h"
#import "OPFCommentViewCell.h"
#import "OPFCommentViewHeaderView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "OPFPost.h"
#import "OPFComment.h"
#import "OPFUserProfileViewController.h"
#import "OPFAppState.h"
#import "OPFUpdateQuery.h"
#import "OPFUser.h"
#import "UIFont+OPFAppFonts.h"

#define INPUT_HEIGHT 44.0f

@interface OPFCommentsViewController ()

@property(nonatomic, strong) NSArray *commentModels;

- (void)opfSetupView;
- (OPFComment *)commentForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation OPFCommentsViewController

static NSString *const OPFCommentTableCell = @"OPFCommentTableCell";
static NSString *const OPFCommentTableHeader = @"OPFCommentTableHeader";
static CGFloat const OPFCommentTableCellOffset = 60.0f;
static CGFloat const OPFCommentTableCellOffsetExtra = 80.0f;

- (id)init
{
    self = [super initWithNibName:@"OPFCommentsViewTable" bundle:nil];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self opfSetupView];
    }
    
    return self;
}

- (void)opfSetupView
{
    self.title = NSLocalizedString(@"Comments", @"Comments view controller title");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFCommentViewHeaderView) bundle:nil] forHeaderFooterViewReuseIdentifier:OPFCommentTableHeader];
    [self.tableView registerNib:[UINib nibWithNibName:CDStringFromClass(OPFCommentViewCell) bundle:nil] forCellReuseIdentifier:OPFCommentTableCell];
}

- (void)setPostModel:(OPFPost *)postModel
{
    _postModel = postModel;
        
    [self performInitialDatabaseFetch];
    
    [self.tableView reloadData];
}

- (OPFPost *)commentForIndexPath:(NSIndexPath *)indexPath
{
    return self.commentModels[indexPath.row];
}

- (void)commentSavePressed:(UIButton *)sender
{
    if(![self.inputTextField.text isEqualToString:@""]){
        NSInteger commentID = [OPFUpdateQuery updateWithCommentText:self.inputTextField.text PostID:[self.postModel.identifier integerValue] ByUser:[[OPFAppState userModel].identifier integerValue]];
        
        // Get the inputed comment and update the commentsview
        __strong OPFComment *comment = [[[OPFComment query] whereColumn:@"id" is:[NSString stringWithFormat:@"%d",commentID]] getOne];
        NSMutableArray *comments = [self.commentModels mutableCopy];
        [comments addObject:comment];
        self.commentModels = [[NSArray alloc] initWithArray:comments];
        
        [self.inputTextField setText:nil];
        [self.inputTextField resignFirstResponder];
        [self scrollToBottomAnimated:YES];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)performInitialDatabaseFetch
{    
    self.commentModels = self.postModel.comments;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Returning 1 because we only display one post's comments
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OPFCommentViewCell *cell = (OPFCommentViewCell *)[tableView dequeueReusableCellWithIdentifier:OPFCommentTableCell forIndexPath:indexPath];
    
    [cell configureForComment:[self.commentModels objectAtIndex:indexPath.row]];
    
    cell.commentsViewController = self;
    
    return cell;
}

- (void)voteUpComment:(UIButton *)sender
{
//    OPFCommentViewCell *subordinateCommentViewCell = (OPFCommentViewCell *)[[sender superview] superview];
//    NSIndexPath *indexPathOfCommentViewCell = [self.tableView indexPathForCell:subordinateCommentViewCell];    
}

- (void)didSelectDisplayName:(UIButton *)sender :(OPFUser *)userModel
{
	OPFUserProfileViewController *userProfileViewController = OPFUserProfileViewController.newFromStoryboard;
    userProfileViewController.user = userModel;
    
    [self.navigationController pushViewController:userProfileViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    OPFCommentViewHeaderView *commentHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OPFCommentTableHeader];
		
    [commentHeaderView configureForPost:self.postModel];
		
    headerView = commentHeaderView;
    
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	OPFComment *commentModel = [self.commentModels objectAtIndex:indexPath.row];
    NSString *text = commentModel.text;
    CGSize textSize = [text sizeWithFont:[UIFont opf_appFontOfSize:14.0f] constrainedToSize:CGSizeMake(267.f, 1000.f) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat offset = textSize.height > 120.f ?  OPFCommentTableCellOffsetExtra : OPFCommentTableCellOffset;
    
    return textSize.height + offset;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self scrollToBottomAnimated:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(handleWillShowKeyboard:)
		name:UIKeyboardWillShowNotification
        object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(handleWillHideKeyboard:)
		name:UIKeyboardWillHideNotification
        object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:[UIView animationOptionsForCurve:curve]
        animations:^{
            CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
            CGRect inputViewFrame = self.inputView.frame;
            CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
            // for ipad modal form presentations
            CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
            if(inputViewFrameY > messageViewFrameBottom)
                inputViewFrameY = messageViewFrameBottom;
                         
            self.inputView.frame = CGRectMake(inputViewFrame.origin.x, inputViewFrameY, inputViewFrame.size.width, inputViewFrame.size.height);
                         
            UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, self.view.frame.size.height - self.inputView.frame.origin.y - INPUT_HEIGHT, 0.0f);

            self.tableView.contentInset = insets;
            self.tableView.scrollIndicatorInsets = insets;
        }
        completion:^(BOOL finished) {
        }];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                        atScrollPosition:UITableViewScrollPositionBottom
                        animated:animated];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self commentSavePressed:self.inputSendButton];
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
