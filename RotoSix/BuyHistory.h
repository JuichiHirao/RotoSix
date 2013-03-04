//
//  BuyHistory.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lottery.h"

@interface BuyHistory : NSObject

@property (nonatomic, assign) NSInteger dbId;
@property (nonatomic, assign) NSInteger isDbUpdate;
@property (nonatomic, strong) NSString *set01;
@property (nonatomic, assign) NSInteger place01;
@property (nonatomic, strong) NSString *set02;
@property (nonatomic, assign) NSInteger place02;
@property (nonatomic, strong) NSString *set03;
@property (nonatomic, assign) NSInteger place03;
@property (nonatomic, strong) NSString *set04;
@property (nonatomic, assign) NSInteger place04;
@property (nonatomic, strong) NSString *set05;
@property (nonatomic, assign) NSInteger place05;
@property (nonatomic, assign) NSInteger lotteryTimes;
@property (nonatomic, strong) NSDate *lotteryDate;
@property (nonatomic, assign) NSString *unit;
@property (nonatomic, assign) NSInteger prizeMoney;
@property (nonatomic, assign) NSInteger lotteryStatus;

@property (nonatomic, assign) NSInteger isSet01Update;
@property (nonatomic, assign) NSInteger isSet02Update;
@property (nonatomic, assign) NSInteger isSet03Update;
@property (nonatomic, assign) NSInteger isSet04Update;
@property (nonatomic, assign) NSInteger isSet05Update;

-(NSString*) getSetNo:(NSInteger)setNoIndex;
-(NSString*) changeSetNo:(NSInteger)setNoIndex SetNo:(NSString *)setNo;
-(NSInteger) getPlace:(NSInteger)setNoIndex;
-(NSInteger) getCount;
-(void) lotteryCheck:(Lottery *) lottery;
-(NSString *)getPlaceImageName:(NSInteger) place;
-(BOOL) isUpdate:(NSInteger)selBuyNo;
-(void) removeSetData:(NSInteger)setNoIndex;
-(void) setUpdate:(NSInteger)selBuyNo Status:(NSInteger)status;
-(void) save;
-(void) remove;

@end
