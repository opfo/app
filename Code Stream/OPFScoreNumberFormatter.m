//
//  OPFScoreNumberFormatter.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 19-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFScoreNumberFormatter.h"


// The maximum score of 
static NSInteger kOPFScoreNumberMaxShortForm = 2048;


@interface OPFScoreNumberFormatter (/*Private*/)
@property (strong, readonly) NSNumberFormatter *numberFormatter;
@end


@implementation OPFScoreNumberFormatter

#pragma mark - Object Lifecycle
- (id)init
{
	self = [super init];
	if (self) {
		_shouldUseLongForm = NO;
		
		_numberFormatter = [NSNumberFormatter new];
		_numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
		_numberFormatter.groupingSeparator = @",";
		_numberFormatter.decimalSeparator = @".";
		_numberFormatter.maximumFractionDigits = 1;
		_numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
	}
	return self;
}


#pragma mark -
- (NSUInteger)scoreFromString:(NSString *)string
{
	NSParameterAssert(string);
	
	NSUInteger score = 0;
	string = string.lowercaseString;
	
	NSRange rangeOfk = [string rangeOfString:@"k"];
	if (rangeOfk.location != NSNotFound) {
		string = [string substringToIndex:rangeOfk.location];
		score = (NSUInteger)([self.numberFormatter numberFromString:string].doubleValue * 1000.f);
	} else {
		score = [self.numberFormatter numberFromString:string].unsignedIntegerValue;
	}
	
	return score;
}

- (NSString *)stringFromScore:(NSUInteger)score
{
	NSString *string = nil;
	if (self.shouldUseLongForm == YES || score <= kOPFScoreNumberMaxShortForm) {
		string = [self.numberFormatter stringFromNumber:@(score)];
	} else {
		double shortFormScore = ((double)score) / 1000.f;
		string = [[self.numberFormatter stringFromNumber:@(shortFormScore)] stringByAppendingString:@"k"];
	}
	return string;
}


@end
