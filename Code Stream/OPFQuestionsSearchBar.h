//
//  OPFQuestionsSearchBar.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>


/// Attribute for marking a range as a specific type (tag or user).
///
/// Example usage to mark a range as a tag:
///
///     attributes = @{ kOPFQuestionsSearchBarTypeName: kOPFQuestionsSearchBarTypeTagAttribute };
///     range = NSMakeRange(10, 3);
///     [mutableAttributeString setAttributes:attributes range:range];
///
extern NSString *const kOPFQuestionsSearchBarTypeName;
extern NSString *const kOPFQuestionsSearchBarTypeTagAttribute;
extern NSString *const kOPFQuestionsSearchBarTypeUserAttribute;


@interface OPFQuestionsSearchBar : UISearchBar

// An array of the ranges in the `searchString` of all tags.
// @see OPFQuestionsSearchBarTokenRange
@property (copy, nonatomic) NSArray *tagRanges;

// An array of the range in the `searchString` for each user.
// @see OPFQuestionsSearchBarTokenRange
@property (copy, nonatomic) NSArray *userRanges;

@property (strong, readonly) UITextField *textField;

@end
