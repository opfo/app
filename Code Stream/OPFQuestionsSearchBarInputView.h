//
//  OPFQuestionsSearchBarInputView.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 01-05-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "SSGradientView.h"


@class OPFQuestionsSearchBarInputButtonsView;
@class GCTagList;


typedef enum : NSInteger {
	kOPFQuestionsSearchBarInputStateButtons,
	kOPFQuestionsSearchBarInputStateCompletions
} OPFQuestionsSearchBarInputState;


@interface OPFQuestionsSearchBarInputView : SSGradientView

@property (assign, nonatomic) OPFQuestionsSearchBarInputState state;

@property (strong, nonatomic, readonly) OPFQuestionsSearchBarInputButtonsView *buttonsView;
@property (strong, nonatomic, readonly) GCTagList *completionsView;

@end
