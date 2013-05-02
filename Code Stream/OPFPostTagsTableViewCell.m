//
//  OPFPostTagsTableViewCell.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 18-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFPostTagsTableViewCell.h"

@implementation OPFPostTagsTableViewCell

- (GCTagLabel *)tagList:(GCTagList *)tagList tagLabelAtIndex:(NSInteger)index {
	static NSString* identifier = @"TagLabelIdentifier";
    GCTagLabel* tag = [tagList dequeueReusableTagLabelWithIdentifier:identifier];
    if(!tag) {
        tag = [GCTagLabel tagLabelWithReuseIdentifier:identifier];
    }
	
    [tag setLabelText:self.tags[index] accessoryType:GCTagLabelAccessoryNone];
	return tag;
}

- (NSInteger)numberOfTagLabelInTagList:(GCTagList *)tagList {
	return self.tags.count;
}




@end
