//
//  OPFPostQuestionViewController.m
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-08.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostQuestionViewController.h"
#import "OPFUpdateQuery.h"
#import "FMResultSet.h"
#import "OPFAppState.h"
#import "OPFUser.h"
#import "OPFLoginViewController.h"
#import "OPFSignupViewController.h"
#import "NSString+OPFMD5Hash.h"
#import "NSString+OPFStripCharacters.h"
#import "UIColor+OPFAppColors.h"
#import <QuartzCore/QuartzCore.h>
#import <BlocksKit.h>
#import "OPFDateFormatter.h"
#import "OPFDBInsertionIdentifier.h"

@interface OPFPostQuestionViewController ()
@property (strong, nonatomic) OPFLoginViewController *loginViewController;
@end

@implementation OPFPostQuestionViewController

const unichar Bullet = 0x25CF;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bodyField.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
    self.bodyField.layer.borderWidth = 2.0;
    self.bodyField.layer.cornerRadius = 10;
    self.bodyField.clipsToBounds = YES;
    self.bulletBarItem.title = [NSString stringWithFormat:@"%C",Bullet];
    self.insertCode.title = @"{}";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(OPFQuestion *) postButtonPressed{
    // Check if all fields are filled in correctly
    if([self.titleField.text isEqualToString:@""]){
        self.titleWarning.text = @"Title is missing";
        self.titleWarning.textColor = [UIColor redColor];
        self.titleWarning.hidden = NO;
    }
    if([self.bodyField.text isEqualToString:@""]){
        self.bodyTextWarning.text = @"Postbody is missing";
        self.bodyTextWarning.textColor = [UIColor redColor];
        self.bodyTextWarning.hidden = NO;
        self.generalWarningLabel.text = @"You forgot to fill in one textfield...";
        self.generalWarningLabel.hidden = NO;
    }
    
    // If required fields are not empty; update database
    if(![self.titleField.text isEqualToString:@""] && ![self.bodyField.text isEqualToString:@""]){
        OPFQuestion *question= [self updateDatabase];
        if(question!=nil){
            return question;
        }
        // If update was unsuccessful
        else{
            UIAlertView *emptyField = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Something terrible has happened" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [emptyField show];
        }
    }
    return nil;
}

// Update database with the data
-(OPFQuestion *) updateDatabase{
    
    // Current date
    NSString *date = [OPFDateFormatter currentDateAsStringWithDateFormat:@"yyyy-MM-dd"];
    int id = [OPFDBInsertionIdentifier getNextPostId];
    
    NSArray *tags = [self.tagsField.text componentsSeparatedByString:@" "];
    NSMutableString *tagsString=[[NSMutableString alloc]initWithString:@""];
    
    for(NSString *s __strong in tags){
        [tagsString appendFormat:@"<%@>",s];
    }
    
    NSString *title = self.titleField.text;
    NSString *body = [NSString stringWithFormat:@"<p>%@</p>",self.bodyField.text];

    OPFUser *user = OPFAppState.sharedAppState.user;
    NSString *userName = user.displayName;
    NSInteger userID = [user.identifier integerValue];
    
    NSArray* args = @[@(id), @1, date, @0, @0, body, @(userID), date, title, tagsString, @0, @0, @0];
    NSArray* col = @[@"id", @"post_type_id", @"creation_date", @"score", @"view_count", @"body", @"owner_user_id", @"last_activity_date", @"title", @"tags", @"answer_count", @"comment_count", @"favorite_count"];
    BOOL succeeded = [OPFUpdateQuery insertInto:@"posts" forColumns:col values:args auxiliaryDB:NO];
    
    col = @[@"object_id", @"main_index_string", @"tags"];
    NSString* index_string = [NSString stringWithFormat:@"%@ %@ %@", body.opf_stringByStrippingHTML, title, userName];
    
    args = @[@(id), index_string, tagsString];
    BOOL auxSucceeded = [OPFUpdateQuery insertInto:@"posts_index" forColumns:col values:args auxiliaryDB:YES];
    
    
    OPFQuestion *question = OPFQuestion.new;
    if(succeeded&&auxSucceeded){
        question.title = self.titleField.text;
        question.body = [NSString stringWithFormat:@"<p>%@</p>",self.bodyField.text];
        question.owner = OPFAppState.sharedAppState.user;
        question.tags = tags;
        question.identifier=@(id);
    }
    
    return question;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField==self.titleField || textField==self.tagsField){
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    [textView setInputAccessoryView:self.keyboardAccessoryView];
    [self.keyboardAccessoryView setItems:@[self.insertCode,self.insertLink,self.insertNumbers, self.bulletBarItem,self.bodyViewFixedBarButtonItem, self.prevField,self.nextField] animated:YES];
    self.bodyField = textView;
    
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField setInputAccessoryView:self.keyboardAccessoryView];
    [self.keyboardAccessoryView setItems:@[self.prevNextFixedBarButtonItem,self.prevField,self.nextField] animated:YES];
    
    CGFloat tHeight = [[UIScreen mainScreen] bounds].size.height-[textField convertPoint:textField.center toView:[UIApplication sharedApplication].keyWindow].y;
    
    NSLog(@"Height: %f", tHeight);
    
    if(tHeight<0)
        [self animateTextField:textField distance:@(tHeight-[[UIScreen mainScreen] bounds].size.height) up: YES];
    else if(tHeight>[[UIScreen mainScreen] bounds].size.height)
        [self animateTextField:textField distance:@(tHeight+[[UIScreen mainScreen] bounds].size.height) up: NO];
    
   // CGRect cr = self.scrollView.frame;
    
  //  CGRect visibleRect = CGRectIntersection(self.scrollView.frame, screenRect);
    
    //[self.scrollView setContentOffset:CGPointMake(x, y) animated:YES];
}

- (void) animateTextField: (UITextField*) textField distance: NSInteger up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


-(IBAction)inputCode{
    // Possible link text
    NSString *markedText = [self.bodyField textInRange:self.bodyField.selectedTextRange];
    
    // Insert text into textfield
    [self.bodyField replaceRange:self.bodyField.selectedTextRange withText:[NSString stringWithFormat:@"<code>%@</code>",markedText]];
    
    // Set cursor position
    UITextPosition *newCursorPosition = [self.bodyField positionFromPosition:self.bodyField.selectedTextRange.start offset:-7];
    UITextRange *newRange = [self.bodyField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
    self.bodyField.selectedTextRange = newRange;
}

-(IBAction) inputLink{
    // Possible link text
    NSString *markedText = [self.bodyField textInRange:self.bodyField.selectedTextRange];
    
    // Insert text into textfield
    [self.bodyField replaceRange:self.bodyField.selectedTextRange withText:[NSString stringWithFormat:@"<a href=\"\">%@</a>",markedText]];
    
    // Set cursor position
    UITextPosition *newCursorPosition = [self.bodyField positionFromPosition:self.bodyField.selectedTextRange.start offset:(-6-markedText.length)];
    UITextRange *newRange = [self.bodyField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
    self.bodyField.selectedTextRange = newRange;
}

-(IBAction)inputBulletList{
    [self.bodyField replaceRange:self.bodyField.selectedTextRange withText:[NSString stringWithFormat:@"%C ",Bullet]];
}
-(IBAction)inputNumberList{
    NSArray *lines = [self.bodyField.text componentsSeparatedByString:@"\n"];
    
    NSString *prevLineNumber;
    if(lines.count>1 && ![(NSString *)[lines objectAtIndex:lines.count-2] isEqualToString:@""])
        prevLineNumber = [(NSString *)[lines objectAtIndex:lines.count-2] substringToIndex:1];

    [self.bodyField replaceRange:self.bodyField.selectedTextRange withText:[NSString stringWithFormat:@"%d. ",[prevLineNumber intValue]+1]];
}

-(IBAction)prev{
    if(self.titleField.isFirstResponder){
        [self.tagsField becomeFirstResponder];
    }
    else if(self.bodyField.isFirstResponder){
        [self.titleField becomeFirstResponder];
        [self.scrollView scrollsToTop];
    }
    else if(self.tagsField.isFirstResponder){
        [self.bodyField becomeFirstResponder];
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
}
-(IBAction)next{
    if(self.titleField.isFirstResponder){
        [self.bodyField becomeFirstResponder];
    }
    else if(self.bodyField.isFirstResponder){
        [self.tagsField becomeFirstResponder];
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
    else if(self.tagsField.isFirstResponder){
        [self.titleField becomeFirstResponder];
    }
}
@end
