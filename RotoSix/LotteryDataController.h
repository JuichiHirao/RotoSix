//
//  LotteryDataController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/01.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lottery.h"
#import "BuyHistory.h"

@interface LotteryDataController : NSObject

@property (nonatomic, copy, readwrite) NSString *dbmstPath;

- (unsigned)countOfList;
- (Lottery *)objectInListAtIndex:(unsigned)theIndex;
- (void)createDemoFromDb;

+ (Lottery *)getTimes:(NSInteger) times;
+ (Lottery *)getSearchNumSetOnlyFirstRow:(NSString *) numset;
+ (NSMutableArray *)getSearchNumSetAll:(NSString *) numset;
+ (NSMutableArray *)addArraySearchNumSet:(NSString *) numset DestArray:(NSMutableArray *)arrDest LotteryRanking:(NSInteger) lotteryRanking;
+ (NSMutableArray *)getSearchNumSet:(NSString *) numset;
+ (NSArray *)getPast:(NSInteger)times MaxRow:(NSInteger)maxrow;
+ (Lottery *)getNewest;
+ (Lottery *)getDataFromJson:(NSDictionary *)dict;

@end
