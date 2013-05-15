//
//  OPFPostAnswerViewController.h
//  Code Stream
//
//  Created by Marcus Johansson on 2013-05-12.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFAnswer.h"

@protocol PostAnswerDelegate <NSObject>

-(void) updateViewWithAnswer:(OPFAnswer *) answer;

@end

@interface OPFPostAnswerViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *answerBody;
@property (weak, nonatomic) IBOutlet UILabel *answerBodyWarning;
@property (nonatomic) NSInteger parentQuestion;
@property (assign) id <PostAnswerDelegate> delegate;
@end


