//
//  NSString+OPFStripCharacters.h
//  Code Stream
//
//  Created by Aron Cedercrantz on 23-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OPFStripCharacters)

- (NSString *)opf_stringByTrimmingWhitespace;

@end
