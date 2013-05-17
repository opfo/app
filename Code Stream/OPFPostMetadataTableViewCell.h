//
//  OPFPostMetadataTableViewCell.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPFPostVoteButton.h"
@class OPFUserPreviewButton;

@interface OPFPostMetadataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet OPFPostVoteButton *voteUpButton;
@property (weak, nonatomic) IBOutlet OPFPostVoteButton *voteDownButton;
@property (weak, nonatomic) IBOutlet OPFUserPreviewButton *userPreviewButton;


@end
