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

@property (nonatomic, copy, readwrite) NSString *dbmstPath;

- (unsigned)countOfList;
- (BuyHistory *)objectInListAtIndex:(unsigned)theIndex;
- (void) reloadAll;
- (void) createDemoFromDb;
- (void) reload:(NSInteger)idx;
- (NSInteger) isDbUpdate:(NSInteger)idx;
- (void) setDbUpdate:(NSInteger)idx;
+ (NSArray *) makeDefaultTimesData;

@end
