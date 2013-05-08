//
//  OPFSingleQuestionPreviewCell.h
//  Code Stream
//
//  Created by Martin Goth on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFQuestion.h"
#import "GCTagList.h"
#import "OPFScoreNumberFormatter.h"

@class OPFUserPreviewButton;

@class OPFSingleQuestionPreviewCell;
@protocol OPFSingleQuestionPreviewCellDelegate <NSObject>
@optional
- (void)singleQuestionPreviewCell:(OPFSingleQuestionPreviewCell *)cell didSelectTag:(NSString *)tag;

@end


@interface OPFSingleQuestionPreviewCell : UITableViewCell <GCTagListDataSource, GCTagListDelegate>

@property (weak) id<OPFSingleQuestionPreviewCellDelegate> delegate;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger answers;

// Array of NSStrings displayed as bubble tags
// Tag view is updated, when this array gets changed.
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, assign) BOOL acceptedAnswer;


// Public: Configure a preview cell with question data
//
// question - The data model that should be represented by the preview cell
- (void) configureWithQuestionData:(OPFQuestion *)question;

// IBOutlet properties linked to SingleQuestionPreviewCell.xib
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *answersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *acceptedAnswerImage;
@property (weak, nonatomic) IBOutlet GCTagList *tagList;

@end
