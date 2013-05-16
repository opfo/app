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

@property (strong, readonly) NSString* modelName;
@property (copy, readonly) NSNumber* identifier;

+(NSDateFormatter*) dateFormatter;
+(NSInteger) defaultPageSize;
+(OPFRootQuery*) query;
+(NSValueTransformer*) standardDateTransformer;
+(NSArray *) parseMultipleResult: (FMResultSet*) result;
+(instancetype) parseDictionary: (NSDictionary*) attributes;
+(NSString*) dbName;
-(BOOL) isEqualToModel:(OPFModel*) other;
@end