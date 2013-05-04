//
//  NSString+NSString_OPFMD5Hash.h
//  Code Stream
//
//  Created by Tobias Deekens on 04.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OPFMD5Hash)

- (NSString*)opf_md5hash:(NSString *) unhashed;

@end
