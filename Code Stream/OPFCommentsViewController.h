//
//  OPFCommentViewController.h
//  Code Stream
//
//  Created by Tobias Deekens on 16.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPFPost;

@interface OPFCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong) OPFPost *postModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *inputSendButton;

- (void)voteUpComment:(UIButton *)sender;

- (IBAction)commentSavePressed:(UIButton *)sender;
- (void)scrollToBottomAnimated:(BOOL)animated;

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification;
- (void)handleWillHideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;
@end