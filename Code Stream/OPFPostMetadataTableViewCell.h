//
//  OPFPostMetadataTableViewCell.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OPFUserPreviewButton;

@interface OPFPostMetadataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *voteUpButton;
@property (weak, nonatomic) IBOutlet UIButton *voteDownButton;

@property (weak, nonatomic) IBOutlet OPFUserPreviewButton *userPreviewButton;


@end
