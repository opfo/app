//
//  OPFQuestionsSearchBar.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 29-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSInteger {
	kOPFQuestionsSearchBarTokenCustom,
	kOPFQuestionsSearchBarTokenTag,
	kOPFQuestionsSearchBarTokenUser
} OPFQuestionsSearchBarTokenType;


@interface OPFQuestionsSearchBarToken : NSObject
+ (instancetype)tokenWithRange:(NSRange)range type:(OPFQuestionsSearchBarTokenType)type;
- (instancetype)initWithRange:(NSRange)range type:(OPFQuestionsSearchBarTokenType)type;
@property (assign, readonly) NSRange range;
@property (assign, readonly) OPFQuestionsSearchBarTokenType type;
@end


@interface OPFQuestionsSearchBar : UISearchBar

@property (copy, nonatomic) NSArray *tokens;

@property (strong, readonly) UITextField *textField;

@end
