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

#define INPUT_HEIGHT 44.0f

@interface OPFCommentsViewController ()

@property(nonatomic, strong) NSArray *commentModels;

- (void)opfSetupView;

@end

@implementation OPFCommentsViewController

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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setPostModel:(OPFPost *)postModel
{
    _postModel = postModel;
        
    [self performInitialDatabaseFetch];
    
    [self.tableView reloadData];
}

- (void)commentSavePressed:(UIButton *)sender
{
    NSString *commentText = self.inputTextField.text;
    
    NSLog(@"%@%@", @"NOP of saving comment: ", commentText);
    
    [self.inputTextField setText:nil];
    [self.inputTextField resignFirstResponder];
    [self scrollToBottomAnimated:YES];
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
    static NSString *commentViewCellIdentifier = @"OPFCommentViewCell";
    
    OPFCommentViewCell *commentViewCell = (OPFCommentViewCell *)[tableView dequeueReusableCellWithIdentifier:commentViewCellIdentifier];
    
    if (commentViewCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:commentViewCellIdentifier owner:self options:nil];
        commentViewCell = [nib objectAtIndex:0];
    }
    
    commentViewCell.commentModel = [self.commentModels objectAtIndex:indexPath.row];
    
    [commentViewCell setupDateformatters];
    [commentViewCell setModelValuesInView];
    
    commentViewCell.commentsViewController = self;
    
    return commentViewCell;
}

- (void)voteUpComment:(UIButton *)sender
{
//    OPFCommentViewCell *subordinateCommentViewCell = (OPFCommentViewCell *)[[sender superview] superview];
//    NSIndexPath *indexPathOfCommentViewCell = [self.tableView indexPathForCell:subordinateCommentViewCell];    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OPFCommentViewHeaderView *commentViewHeader = [OPFCommentViewHeaderView new];
    
    commentViewHeader.postModel = self.postModel;
    
    [commentViewHeader setupDateformatters];
    [commentViewHeader setModelValuesInView];
    
    return commentViewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
