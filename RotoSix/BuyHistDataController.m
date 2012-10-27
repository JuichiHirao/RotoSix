//
//  BuyHistDataController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistDataController.h"
#import "BuyHistory.h"
#import "FMDatabase.h"

@interface BuyHistDataController()
@property (nonatomic, copy, readwrite) NSMutableArray *list;
- (void)createDemoData;
- (void)testdb;
@end

@implementation BuyHistDataController

@synthesize list;

-(id)init {
    if (self = [super init]) {
        [self createDemoFromDb];
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

-(void)createDemoFromDb {
    //呼び出したいメソッドで下記を実行
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", writableDBPath]);
    
    BOOL result_flag = [fm fileExistsAtPath:writableDBPath];
    if(result_flag){
        [fm removeItemAtPath:writableDBPath error:nil];
    }
    
    //dbが存在してなかったらここが呼ばれて、作成したDBをコピー
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"defaultDBPath [%@]", defaultDBPath]);
    
    BOOL copy_result_flag = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if(!copy_result_flag){
        //失敗したらここ
        NSLog(@"%@", [NSString stringWithFormat:@"copy failed"]);
    }
    
    NSMutableArray *listBuyHist = [[NSMutableArray alloc] init];

    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT lottery_no, set01, set02, set03, set04, set05, lottery_amount, lottery_date FROM buy_history order by lottery_no desc"];
        while ([rs next]) {
            BuyHistory *buyHist;

            buyHist = [[BuyHistory alloc]init];
            buyHist.set01 = [rs stringForColumn:@"set01"];
            buyHist.set02 = [rs stringForColumn:@"set02"];
            buyHist.set03 = [rs stringForColumn:@"set03"];
            buyHist.set04 = [rs stringForColumn:@"set04"];
            buyHist.set05 = [rs stringForColumn:@"set05"];
            buyHist.lotteryDate = [rs dateForColumn:@"lottery_date"];
//            buyHist.unit = 2;
//            buyHist.lotteryDate = [dateFormatter dateFromString:@"20120601"];
            buyHist.lotteryNo = [rs intForColumn:@"lottery_no"];
            
            [listBuyHist addObject:buyHist];

            //ここでデータを展開
            NSLog(@"%d %@ %@ %@ %@ %@ %d %@", [rs intForColumn:@"lottery_no"], [rs stringForColumn:@"set01"]
                  , [rs stringForColumn:@"set02"], [rs stringForColumn:@"set03"], [rs stringForColumn:@"set04"]
                  , [rs stringForColumn:@"set05"], [rs intForColumn:@"lottery_amount"], [rs dateForColumn:@"lottery_date"]);
        }
        [rs close];
        [db close];
        
        list = listBuyHist;
    }else{
        //DBが開けなかったらここ
    }    
}

@end
