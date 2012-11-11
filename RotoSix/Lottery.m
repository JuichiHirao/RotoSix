//
//  Lottery.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/01.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "Lottery.h"

@implementation Lottery

@synthesize dbId, lotteryDate, times, num_set, one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover;

- (NSComparisonResult)compareTimes:(Lottery *)data {
    if (self.times > data.times) {
        return NSOrderedDescending;
    }
    else if (self.times < data.times) {
        return NSOrderedAscending;
    }
    else {
        return NSOrderedSame;
    }
}

-(NSString *)getDisplayStringDate {
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    
}


@end
