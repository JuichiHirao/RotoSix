//
//  BuyHistory.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyHistory : NSObject

@property (nonatomic, strong) NSString *set01;
@property (nonatomic, strong) NSString *set02;
@property (nonatomic, strong) NSString *set03;
@property (nonatomic, strong) NSString *set04;
@property (nonatomic, strong) NSString *set05;
@property (nonatomic, assign) NSInteger lotteryNo;
@property (nonatomic, strong) NSDate *lotteryDate;
@property (nonatomic, assign) NSInteger unit;
@property (nonatomic, assign) NSInteger prizeMoney;

-(NSString*) getSetNo:(NSInteger)setNoIndex;

@end
