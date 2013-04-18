//
//  OPFModel.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OPFModel <NSObject>
@required
+ (NSArray *) all;
+ (instancetype) find: (NSInteger) identifier;
+ (NSArray *) where: (NSDictionary *) attributes;
@end
