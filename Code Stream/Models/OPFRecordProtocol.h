//
//  OPFModel.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OPFRecordProtocol <NSObject>
@required
+ (NSArray *) all;
+ (NSArray *) all: (NSInteger) page;
+ (NSArray *) all: (NSInteger) page per: (NSInteger) pageSize;
+ (instancetype) find: (NSInteger) identifier;
+ (NSArray *) where: (NSDictionary *) attributes;
+ (NSString*) modelTableName;
+ (instancetype) parseDictionary: (NSDictionary*) attribute;
@end