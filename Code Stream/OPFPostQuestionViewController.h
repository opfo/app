//
//  OPFPostQuestionViewController.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-08.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFQuestion.h"

@interface OPFPostQuestionViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *tagsField;
@property (weak, nonatomic) IBOutlet UILabel *titleWarning;
@property (weak, nonatomic) IBOutlet UILabel *bodyTextWarning;
@property (weak, nonatomic) IBOutlet UILabel *generalWarningLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *insertNumbers;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *insertCode;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *insertLink;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fixedBarItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *prevField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bulletBarItem;
@property (weak, nonatomic) IBOutlet UITextView *bodyField;



@property (strong, nonatomic) IBOutlet UIToolbar *keyboardAccessoryView;

-(IBAction)inputCode;
-(IBAction)inputLink;
-(IBAction)prev;
-(IBAction)next;
-(IBAction)inputBulletList;
-(IBAction)inputNumberList;
-(OPFQuestion *) postButtonPressed;

@end
