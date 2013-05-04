//
//  OPFModel.h
//  Code Stream
//
//  Created by Jesper Josefsson on 2013-04-18.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Mantle.h"  
#import "OPFDatabaseAccess.h"
#import "OPFRecordProtocol.h"
#import "OPFQuery.h"
#import "OPFQueryable.h"

@interface OPFModel : MTLModel <MTLJSONSerializing, OPFRecordProtocol, OPFQueryable>

@property (copy, readonly) NSString* modelName;

+(NSDateFormatter*) dateFormatter;
+(NSInteger) defaultPageSize;
+(OPFRootQuery*) query;
+(NSValueTransformer*) standardDateTransformer;
+(NSArray *) parseMultipleResult: (FMResultSet*) result;
+(instancetype) parseDictionary: (NSDictionary*) attributes;
+(NSString*) dbName;
@end