//
//  BuyHistDataController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuyHistory;
@class Lottery;

@interface BuyHistDataController : NSObject

- (unsigned)countOfList;
- (BuyHistory *)objectInListAtIndex:(unsigned)theIndex;
- (void)removeObjectInListAtIndex:(unsigned)theIndex;
- (void) loadAll;
- (void) reload:(NSInteger)idx;
- (NSInteger) isDbUpdate:(NSInteger)idx;
- (void) setDbUpdate:(NSInteger)idx;
+ (NSArray *) makeDefaultTimesData;
+ (NSArray *) makePastTimesData:(NSArray *)arrLottery;
+ (NSMutableArray *)getTimes:(NSInteger)times;

@end
