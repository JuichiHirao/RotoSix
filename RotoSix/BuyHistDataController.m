//
//  BuyHistDataController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistDataController.h"
#import "BuyHistory.h"

@interface BuyHistDataController()
@property (nonatomic, copy, readwrite) NSMutableArray *list;
- (void)createDemoData;
@end

@implementation BuyHistDataController

@synthesize list;

-(id)init {
    if (self = [super init]) {
        [self createDemoData];
    }
    return self;
}

- (unsigned)countOfList {
    return [list count];
}

- (BuyHistory *)objectInListAtIndex:(unsigned)theIndex {
    return [list objectAtIndex:theIndex];
}

-(void)createDemoData {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];

    NSMutableArray *listBuyHist = [[NSMutableArray alloc] init];
    BuyHistory *buyHist;
    
    buyHist = [[BuyHistory alloc]init];
    buyHist.set01 = @"01,05,08,09,10,12";
    buyHist.set02 = @"02,03,05,22,33,41";
    buyHist.set03 = @"02,03,05,22,33,41";
    buyHist.unit = 1;
    buyHist.lotteryDate = [dateFormatter dateFromString:@"20120608"];
    buyHist.lotteryNo = 386;

    [listBuyHist addObject:buyHist];
    
    buyHist = [[BuyHistory alloc]init];
    buyHist.set01 = @"02,07,11,14,20,27";
    buyHist.set02 = @"02,03,11,20,27,35";
    buyHist.set03 = @"09,24,26,31,32,42";
    buyHist.set04 = @"15,19,24,30,34,36";
    buyHist.set05 = @"01,03,07,17,26,39";
    buyHist.unit = 2;
    buyHist.lotteryDate = [dateFormatter dateFromString:@"20120601"];
    buyHist.lotteryNo = 385;
    
    [listBuyHist addObject:buyHist];
    
    list = listBuyHist;

}
@end
