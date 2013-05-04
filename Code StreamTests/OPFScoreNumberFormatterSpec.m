//
//  OPFScoreNumberFormatterSpec.m
//  Code Stream
//
//  Created by Aron Cedercrantz on 19-04-2013.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OPFScoreNumberFormatter.h"

SpecBegin(OPFScoreNumberFormatter)

describe(@"converting a score number into a string using _short_ form", ^{
	OPFScoreNumberFormatter *scoreFormatter = [OPFScoreNumberFormatter new];
	scoreFormatter.shouldUseLongForm = NO;
	
	it(@"should return a string containing '2k' for a number higher than 2048 and lower than 2050", ^{
		expect([scoreFormatter stringFromScore:2049]).to.equal(@"2k");
	});
	
	it(@"should return a string containing '2.1k' for a number higher between (inclusive) 2050 and 2149", ^{
		expect([scoreFormatter stringFromScore:2049]).toNot.equal(@"2.1k");
		expect([scoreFormatter stringFromScore:2050]).to.equal(@"2.1k");
		expect([scoreFormatter stringFromScore:2100]).to.equal(@"2.1k");
		expect([scoreFormatter stringFromScore:2149]).to.equal(@"2.1k");
		expect([scoreFormatter stringFromScore:2150]).toNot.equal(@"2.1k");
	});
	
	it(@"should return a string containing the number passed in if the number is lower or equal to 2048", ^{
		expect([scoreFormatter stringFromScore:0]).to.equal(@"0");
		expect([scoreFormatter stringFromScore:123]).to.equal(@"123");
		expect([scoreFormatter stringFromScore:2048]).to.equal(@"2,048");
	});
	
	it(@"should return a string containing the number passed in grouped by the thousands using a comma if the number is larger than or equal to 1,000,000", ^{
		expect([scoreFormatter stringFromScore:1000000]).to.equal(@"1,000k");
		expect([scoreFormatter stringFromScore:2048000]).to.equal(@"2,048k");
	});
	
	it(@"should handle negative scores in the same manner", ^{
		expect([scoreFormatter stringFromScore:-1]).to.equal(@"-1");
		expect([scoreFormatter stringFromScore:-2048]).to.equal(@"-2,048");
		expect([scoreFormatter stringFromScore:-2049]).to.equal(@"-2k");
		expect([scoreFormatter stringFromScore:-2050]).to.equal(@"-2.1k");
	});
	
	it(@"should not be nil", ^{
		expect([scoreFormatter stringFromScore:0]).toNot.beNil();
		expect([scoreFormatter stringFromScore:2048]).toNot.beNil();
		expect([scoreFormatter stringFromScore:NSUIntegerMax]).toNot.beNil();
	});
});

describe(@"converting a score number into a string using _long_ form", ^{
	OPFScoreNumberFormatter *scoreFormatter = [OPFScoreNumberFormatter new];
	scoreFormatter.shouldUseLongForm = YES;
	
	it(@"should return a string containing the number passed in if the number is lower or equal to 2048", ^{
		expect([scoreFormatter stringFromScore:0]).to.equal(@"0");
		expect([scoreFormatter stringFromScore:123]).to.equal(@"123");
		expect([scoreFormatter stringFromScore:2048]).to.equal(@"2,048");
	});
	
	it(@"should return a string containing the number passed in grouped by the thousands using a comma if the number is larger than or equal to 1000", ^{
		expect([scoreFormatter stringFromScore:2048]).to.equal(@"2,048");
	});
	
	it(@"should return a string containing the number passed in grouped by the thousands using a comma if the number is larger than 2048", ^{
		expect([scoreFormatter stringFromScore:2049]).to.equal(@"2,049");
		expect([scoreFormatter stringFromScore:100000]).to.equal(@"100,000");
	});
});

describe(@"converting a score string into a number", ^{
	OPFScoreNumberFormatter *scoreFormatter = [OPFScoreNumberFormatter new];
	
	it(@"should multiply a short form number with 1000", ^{
		expect([scoreFormatter scoreFromString:@"5.3k"]).to.equal(@(5300));
	});
	
	it(@"should return the score from a long form score string", ^{
		expect([scoreFormatter scoreFromString:@"0"]).to.equal(@(0));
		expect([scoreFormatter scoreFromString:@"999"]).to.equal(@(999));
	});
	
	it(@"should return the score from a long form score string which contains thousands separators", ^{
		expect([scoreFormatter scoreFromString:@"1,000"]).to.equal(@(1000));
	});
});

SpecEnd


