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
#import "LotteryDataController.h"

@interface BuyHistDataController()
@property (nonatomic, copy, readwrite) NSMutableArray *list;
- (void)createDemoData;
@end

@implementation BuyHistDataController

@synthesize dbmstPath;
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
    buyHist.lotteryTimes = 386;

    [listBuyHist addObject:buyHist];
    
    buyHist = [[BuyHistory alloc]init];
    buyHist.set01 = @"02,07,11,14,20,27";
    buyHist.set02 = @"02,03,11,20,27,35";
    buyHist.set03 = @"09,24,26,31,32,42";
    buyHist.set04 = @"15,19,24,30,34,36";
    buyHist.set05 = @"01,03,07,17,26,39";
    buyHist.unit = 2;
    buyHist.lotteryDate = [dateFormatter dateFromString:@"20120601"];
    buyHist.lotteryTimes = 385;
    
    [listBuyHist addObject:buyHist];
    
    list = listBuyHist;
}

/** pickerviewに表示するための回数を取得する
 *
 * @return 0 〜 9 過去   10 直近   11 〜 14 未来
 */
+ (NSArray *) makeDefaultTimesData {
    NSMutableArray *marrLottery = [[NSMutableArray alloc] init];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    //lbLotteryDate.text = [outputDateFormatter stringFromDate:buyHistAtIndex.lotteryDate];

    int cnt = 0, diffDay = 0;

    // sqlite3から最新の回数を取得する
    Lottery *lottery = [LotteryDataController getNewest];
    
    // 現在日付から直近の抽選日
    while (1==1) {
        date = [NSDate dateWithTimeIntervalSinceNow:diffDay*24*60*60];
        comps = [calendar components:(NSWeekdayCalendarUnit)
                            fromDate:date];
        
        // 抽選曜日の月曜日か木曜日の場合
        if ([comps weekday] == 2 || [comps weekday] == 5) {
            break;
        }
        
        diffDay--;
        
        if (cnt >= 10) {
            break;
        }
    }
    
    // return用の配列へ格納するため退避
    Lottery *lotteryNewest = [[Lottery alloc] init];
    lotteryNewest.lotteryDate = date;

    // ログ出力
    comps = [calendar components:(NSDayCalendarUnit) fromDate:lotteryNewest.lotteryDate toDate:lottery.lotteryDate options:0];
    diffDay = [comps day];
    NSLog(@"直近の抽選日 %@ 登録の抽選日 %@ 回数 %d  差の日数 %d", [outputDateFormatter stringFromDate:date]
          , [outputDateFormatter stringFromDate:lottery.lotteryDate], lottery.times, diffDay);
    
    int times = lottery.times;
    if (diffDay < 0) {
        // sqliteの登録日が過去な場合は計算して直近の抽選日の回数を取得する
        diffDay = 1;
        while (1==1) {
            date = [NSDate dateWithTimeInterval:diffDay*24*60*60 sinceDate:lottery.lotteryDate];
            comps = [calendar components:(NSWeekdayCalendarUnit) fromDate:date];
            
            // 抽選曜日の月曜日か木曜日の場合
            if ([comps weekday] == 2 || [comps weekday] == 5) {
                times++;
                comps = [calendar components:(NSDayCalendarUnit) fromDate:lotteryNewest.lotteryDate toDate:date options:0];
                //diffDay = [comps day];
                if ([comps day] >= 0) {
                    NSLog(@"直近の回数 %d", times);
                    break;
                }
            }
            
            diffDay++;
        }
    }
    lotteryNewest.times = times;
    
    if (diffDay == 0) {
        // 最新の情報が取得されている場合はsqlite3から過去10回の情報を取得する
    }
    else {
        // 最新の情報が取得できない場合は計算して過去10回の情報を取得する
        diffDay = -1; // 直近の抽選日は取得できているので、含めない
        cnt = 0;
        // 過去の日付10個（直近を除いて9個）
        while (1==1) {
            date = [NSDate dateWithTimeInterval:diffDay*24*60*60 sinceDate:lotteryNewest.lotteryDate];
            comps = [calendar components:(NSWeekdayCalendarUnit)
                                fromDate:date];
            
            // 抽選曜日の月曜日か木曜日の場合
            if ([comps weekday] == 2 || [comps weekday] == 5) {
                times--;
                Lottery *lotteryPast = [[Lottery alloc] init];
                lotteryPast.lotteryDate = date;
                lotteryPast.times = times;
                
                [marrLottery addObject:lotteryPast];
                //NSLog(@"過去 CALC %02d 抽選日 %@", cnt, [outputDateFormatter stringFromDate:date]);
                cnt++;
            }
            
            diffDay--;

            if (cnt >= 9) {
                break;
            }
        }
        
        [marrLottery addObject:lotteryNewest];

        // 未来の日付 5個
        times = lotteryNewest.times;
        diffDay = 1;
        cnt = 0;
        while (1==1) {
            date = [NSDate dateWithTimeInterval:diffDay*24*60*60 sinceDate:lotteryNewest.lotteryDate];
            //date = [NSDate dateWithTimeIntervalSinceNow:diffDay*24*60*60];
            comps = [calendar components:(NSWeekdayCalendarUnit) fromDate:date];
            // 抽選曜日の月曜日か木曜日の場合
            if ([comps weekday] == 2 || [comps weekday] == 5) {
                times++;
                Lottery *lotteryFuture = [[Lottery alloc] init];
                lotteryFuture.lotteryDate = date;
                lotteryFuture.times = times;
                
                //NSLog(@"未来 CALC %02d  回数 %d 抽選日 %@", cnt, lotteryFuture.times, [outputDateFormatter stringFromDate:lotteryFuture.lotteryDate]);
                [marrLottery addObject:lotteryFuture];
                cnt++;
            }
            
            diffDay++;
            
            if (cnt >= 5) {
                break;
            }
        }
    }
    
    NSArray *sortedArray = [marrLottery sortedArrayUsingSelector:@selector(compareTimes:)];
    for (int idx=0; idx<[sortedArray count]; idx++) {
        Lottery *lottery = [sortedArray objectAtIndex:idx];
        //NSLog(@"idx[%d] 回数 %d  抽選日 %@", idx, lottery.times, [outputDateFormatter stringFromDate:lottery.lotteryDate]);
    }
    
    return sortedArray;
}

-(void)createDemoFromDb {
    //呼び出したいメソッドで下記を実行
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    dbmstPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", dbmstPath]);
/*  本来のマスタの処理としては正しいが、mst.dbを変更dbとして使用するので一時的にコメントアウト */
    BOOL result_flag = [fm fileExistsAtPath:dbmstPath];
    if(result_flag){
        [fm removeItemAtPath:dbmstPath error:nil];
    }
    
    //dbが存在してなかったらここが呼ばれて、作成したDBをコピー
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"defaultDBPath [%@]", defaultDBPath]);
    
    BOOL copy_result_flag = [fm copyItemAtPath:defaultDBPath toPath:dbmstPath error:&error];
    if(!copy_result_flag){
        //失敗したらここ
        NSLog(@"%@", [NSString stringWithFormat:@"copy failed"]);
    }
/* */
    
    NSMutableArray *listBuyHist = [[NSMutableArray alloc] init];

    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:dbmstPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_times, set01, set02, set03, set04, set05, lottery_amount, lottery_date FROM buy_history order by lottery_times desc"];
        while ([rs next]) {
            BuyHistory *buyHist;

            buyHist = [[BuyHistory alloc]init];
            buyHist.dbId = [rs intForColumn:@"id"];
            buyHist.set01 = [rs stringForColumn:@"set01"];
            buyHist.set02 = [rs stringForColumn:@"set02"];
            buyHist.set03 = [rs stringForColumn:@"set03"];
            buyHist.set04 = [rs stringForColumn:@"set04"];
            buyHist.set05 = [rs stringForColumn:@"set05"];
            buyHist.lotteryDate = [rs dateForColumn:@"lottery_date"];
//            buyHist.unit = 2;
//            buyHist.lotteryDate = [dateFormatter dateFromString:@"20120601"];
            buyHist.lotteryTimes = [rs intForColumn:@"lottery_times"];
            
            [listBuyHist addObject:buyHist];

            //ここでデータを展開
            NSLog(@"%d %@ %@ %@ %@ %@ %d %@", [rs intForColumn:@"lottery_times"], [rs stringForColumn:@"set01"]
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
-(void)reload:(NSInteger)idx {
    BuyHistory *buyHist = [list objectAtIndex:idx];
    
    // このフラグのチェックにより初期表示時のviewWillAppearの呼び出しを無視する
    if (buyHist.isDbUpdate != 1) {
        return;
    }
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:dbmstPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT set01, set02, set03, set04, set05 FROM buy_history WHERE id = ?", [NSNumber numberWithInteger:buyHist.dbId]];
        while ([rs next]) {
            buyHist.set01 = [rs stringForColumn:@"set01"];
            buyHist.set02 = [rs stringForColumn:@"set02"];
            buyHist.set03 = [rs stringForColumn:@"set03"];
            buyHist.set04 = [rs stringForColumn:@"set04"];
            buyHist.set05 = [rs stringForColumn:@"set05"];

            [list replaceObjectAtIndex:idx withObject:buyHist];
            
            //ここでデータを展開
            NSLog(@"%d 01[%@] 02[%@] 03[%@] 04[%@] 05[%@]", buyHist.dbId, [rs stringForColumn:@"set01"]
                  , [rs stringForColumn:@"set02"], [rs stringForColumn:@"set03"], [rs stringForColumn:@"set04"]
                  , [rs stringForColumn:@"set05"]);
        }
        [rs close];
        [db close];
    }else{
        //DBが開けなかったらここ
    }    
}

+ (BuyHistory *)newestBuyHistory {
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbmstPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    //NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", dbmstPath]);
    
    BuyHistory *buyHist = [[BuyHistory alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:dbmstPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_times, set01, set02, set03, set04, set05, lottery_amount, lottery_date FROM buy_history order by lottery_times desc"];
        if ([rs next]) {
            buyHist.dbId = [rs intForColumn:@"id"];
            buyHist.set01 = [rs stringForColumn:@"set01"];
            buyHist.set02 = [rs stringForColumn:@"set02"];
            buyHist.set03 = [rs stringForColumn:@"set03"];
            buyHist.set04 = [rs stringForColumn:@"set04"];
            buyHist.set05 = [rs stringForColumn:@"set05"];
            buyHist.lotteryDate = [rs dateForColumn:@"lottery_date"];
            //            buyHist.unit = 2;
            //            buyHist.lotteryDate = [dateFormatter dateFromString:@"20120601"];
            buyHist.lotteryTimes = [rs intForColumn:@"lottery_times"];
            
            //ここでデータを展開
            NSLog(@" id[%d] 01[%@] 02[%@] 03[%@] 04[%@] 05[%@]", buyHist.dbId, [rs stringForColumn:@"set01"]
                  , [rs stringForColumn:@"set02"], [rs stringForColumn:@"set03"], [rs stringForColumn:@"set04"]
                  , [rs stringForColumn:@"set05"]);
        }
        [rs close];
        [db close];
    }else{
        //DBが開けなかったらここ
    }
    
    return buyHist;
}

- (NSInteger) isDbUpdate:(NSInteger)idx {
    BuyHistory *buyHist = [list objectAtIndex:idx];
    
    return buyHist.isDbUpdate;
}

- (void) setDbUpdate:(NSInteger)idx {
    BuyHistory *buyHist = [list objectAtIndex:idx];
    
    buyHist.isDbUpdate = 0;

    return;
}

@end
