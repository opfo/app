//
//  NSString+OPFEscapeStrings.h
//  Code Stream
//
//  Created by Martin Goth on 2013-05-02.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum escapeSchemes { OPFEscapePrettify, OPFEscapeHtml, OPFStripAscii, OPFEscapeHtmlPrettify } OPFEscapeScheme;

@interface NSString (OPFEscapeStrings)

- (NSString*) OPF_escapeWithScheme:(OPFEscapeScheme) scheme;

@end
