//
//  Lottery.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/01.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lottery : NSObject

@property (nonatomic, assign) NSInteger dbId;
@property (nonatomic, strong) NSDate *lotteryDate;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) NSString *num_set;
@property (nonatomic, assign) NSInteger one_unit;
@property (nonatomic, assign) NSInteger one_amount;
@property (nonatomic, assign) NSInteger two_unit;
@property (nonatomic, assign) NSInteger two_amount;
@property (nonatomic, assign) NSInteger three_unit;
@property (nonatomic, assign) NSInteger three_amount;
@property (nonatomic, assign) NSInteger four_unit;
@property (nonatomic, assign) NSInteger four_amount;
@property (nonatomic, assign) NSInteger five_unit;
@property (nonatomic, assign) NSInteger five_amount;
@property (nonatomic, assign) long sales;
@property (nonatomic, assign) NSInteger carryover;
@property (nonatomic, assign) NSInteger lotteryRanking; // 検索時にのみ使用するプロパティ（ヒット時の当選順を格納）

-(void)save;

@end
