//
//  LotteryDataController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/01.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "LotteryDataController.h"
#import "Lottery.h"
#import "FMDatabase.h"

@interface LotteryDataController()
@property (nonatomic, copy, readwrite) NSMutableArray *list;

@end

@implementation LotteryDataController

@synthesize dbmstPath;
@synthesize list;

-(void)createDemoFromDb {
    //呼び出したいメソッドで下記を実行
    //NSError *error;
    //NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    dbmstPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", dbmstPath]);
    /*  本来のマスタの処理としては正しいが、mst.dbを変更dbとして使用するので一時的にコメントアウト
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
     */
    
    NSMutableArray *listLottery = [[NSMutableArray alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:dbmstPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set,one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM buy_history order by lottery_no desc"];
        while ([rs next]) {
            Lottery *lottery;
            
            lottery = [[Lottery alloc]init];
            lottery.dbId = [rs intForColumn:@"id"];
            lottery.lotteryDate = [rs dateForColumn:@"lottery_date"];
            lottery.times = [rs intForColumn:@"times"];
            lottery.num_set = [rs stringForColumn:@"num_set"];
            lottery.one_unit = [rs intForColumn:@"one_unit"];
            lottery.one_amount = [rs intForColumn:@"one_amount"];
            lottery.two_unit = [rs intForColumn:@"two_unit"];
            lottery.two_amount = [rs intForColumn:@"two_amount"];
            lottery.three_unit = [rs intForColumn:@"three_unit"];
            lottery.three_amount = [rs intForColumn:@"three_amount"];
            lottery.four_unit = [rs intForColumn:@"four_unit"];
            lottery.four_amount = [rs intForColumn:@"four_amount"];
            lottery.five_unit = [rs intForColumn:@"five_unit"];
            lottery.five_amount = [rs intForColumn:@"five_amount"];
            lottery.sales = [rs intForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
            
            [listLottery addObject:lottery];
            
            //ここでデータを展開
            NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %d %d", lottery.dbId, lottery.lotteryDate, lottery.times
                  , lottery.num_set, lottery.one_unit, lottery.one_amount, lottery.two_unit, lottery.two_amount
                  , lottery.three_unit, lottery.three_amount, lottery.four_unit, lottery.four_amount
                  , lottery.five_unit, lottery.five_amount, lottery.sales, lottery.carryover);
        }
        [rs close];
        [db close];
        
        list = listLottery;
    }else{
        //DBが開けなかったらここ
    }    
}

+(Lottery *)getTimes:(NSInteger) times {
    
    Lottery *lottery;

    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *mstPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", mstPath]);
        
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:mstPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set,one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM lottery WHERE times = ?", [NSNumber numberWithInteger:times]];
        int cnt = 0;
        while ([rs next]) {
            
            lottery = [[Lottery alloc]init];
            lottery.dbId = [rs intForColumn:@"id"];
            lottery.lotteryDate = [rs dateForColumn:@"lottery_date"];
            lottery.times = [rs intForColumn:@"times"];
            lottery.num_set = [rs stringForColumn:@"num_set"];
            lottery.one_unit = [rs intForColumn:@"one_unit"];
            lottery.one_amount = [rs intForColumn:@"one_amount"];
            lottery.two_unit = [rs intForColumn:@"two_unit"];
            lottery.two_amount = [rs intForColumn:@"two_amount"];
            lottery.three_unit = [rs intForColumn:@"three_unit"];
            lottery.three_amount = [rs intForColumn:@"three_amount"];
            lottery.four_unit = [rs intForColumn:@"four_unit"];
            lottery.four_amount = [rs intForColumn:@"four_amount"];
            lottery.five_unit = [rs intForColumn:@"five_unit"];
            lottery.five_amount = [rs intForColumn:@"five_amount"];
            lottery.sales = [rs longForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
                        
            //ここでデータを展開
            NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %lu %d", lottery.dbId, lottery.lotteryDate, lottery.times
                  , lottery.num_set, lottery.one_unit, lottery.one_amount, lottery.two_unit, lottery.two_amount
                  , lottery.three_unit, lottery.three_amount, lottery.four_unit, lottery.four_amount
                  , lottery.five_unit, lottery.five_amount, lottery.sales, lottery.carryover);
            cnt++;
        }
        if (cnt<=0) {
            NSLog(@"lottery NO DATA!!");
        }
        [rs close];
        [db close];
        
    }else{
        //DBが開けなかったらここ
    }
    return lottery;
}

+ (Lottery *)getNewest {
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbmstPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    //NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", dbmstPath]);
    
    Lottery *lottery = [[Lottery alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:dbmstPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];

        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set,one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM lottery ORDER BY lottery_date DESC"];
        
        if ([rs next]) {
            
            lottery = [[Lottery alloc]init];
            lottery.dbId = [rs intForColumn:@"id"];
            lottery.lotteryDate = [rs dateForColumn:@"lottery_date"];
            lottery.times = [rs intForColumn:@"times"];
            lottery.num_set = [rs stringForColumn:@"num_set"];
            lottery.one_unit = [rs intForColumn:@"one_unit"];
            lottery.one_amount = [rs intForColumn:@"one_amount"];
            lottery.two_unit = [rs intForColumn:@"two_unit"];
            lottery.two_amount = [rs intForColumn:@"two_amount"];
            lottery.three_unit = [rs intForColumn:@"three_unit"];
            lottery.three_amount = [rs intForColumn:@"three_amount"];
            lottery.four_unit = [rs intForColumn:@"four_unit"];
            lottery.four_amount = [rs intForColumn:@"four_amount"];
            lottery.five_unit = [rs intForColumn:@"five_unit"];
            lottery.five_amount = [rs intForColumn:@"five_amount"];
            lottery.sales = [rs longForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
        }

        //ここでデータを展開
        NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %lu %d", lottery.dbId, lottery.lotteryDate, lottery.times
              , lottery.num_set, lottery.one_unit, lottery.one_amount, lottery.two_unit, lottery.two_amount
              , lottery.three_unit, lottery.three_amount, lottery.four_unit, lottery.four_amount
              , lottery.five_unit, lottery.five_amount, lottery.sales, lottery.carryover);

        [rs close];
        [db close];
    }else{
        //DBが開けなかったらここ
    }
    
    return lottery;
}


@end
