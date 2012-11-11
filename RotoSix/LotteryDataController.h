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

+ (Lottery *)getTimes:(NSInteger) times;
+ (Lottery *)getNewest;

@end
