//
//  OPFTagBrowserFooter.h
//  Code Stream
//
//  Created by Tobias Deekens on 10.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFTagBrowserFooter : UIView

@property (weak, nonatomic) IBOutlet UIButton *questionsCount;

- (IBAction)showMatchingQuestions:(UIButton *)sender;

@end
