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
- (void)testdb;
@end

@implementation BuyHistDataController

@synthesize dbmstPath;
@synthesize list;

-(id)init {
    if (self = [super init]) {
        [self createDemoFromDb];
        [self makeDefaultTimesData];
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

- (void) makeDefaultTimesData {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps, *compsDate, *compsWeekday;
    
    // 年月日をとりだす
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                        fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSLog(@"year: %d month: %d, day: %d", year, month, day);
    //=> year: 2010 month: 5, day: 22
    
    // 週や曜日などをとりだす
    comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                        fromDate:date];
    NSInteger week = [comps week]; // 今年に入って何週目か
    NSInteger weekday = [comps weekday]; // 曜日
    NSInteger weekdayOrdinal = [comps weekdayOrdinal]; // 今月の第何曜日か
    NSLog(@"week: %d weekday: %d weekday ordinal: %d", week, weekday, weekdayOrdinal);
    //=> week: 21 weekday: 7(日曜日) weekday ordinal: 4(第4日曜日)

    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    //lbLotteryDate.text = [outputDateFormatter stringFromDate:buyHistAtIndex.lotteryDate];

    int cnt = 0, diffDay = 0;

    // sqlite3から最新の回数を取得する
    Lottery *lottery = [LotteryDataController getNewest];
    
    // 直近の抽選日
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
    NSDate *lotteryNewestDate = date;

    comps = [calendar components:(NSDayCalendarUnit) fromDate:lotteryNewestDate toDate:lottery.lotteryDate options:0];
    diffDay = [comps day];
    NSLog(@"直近の抽選日 %@ 登録の抽選日 %@ 回数 %d  差の日数 %d", [outputDateFormatter stringFromDate:date]
          , [outputDateFormatter stringFromDate:lottery.lotteryDate], lottery.times, diffDay);
    
    int times = lottery.times;
    // sqliteの登録日が過去な場合は計算して直近の抽選日の回数を取得する
    if (diffDay < 0) {
        diffDay = 1;
        while (1==1) {
            date = [NSDate dateWithTimeInterval:diffDay*24*60*60 sinceDate:lottery.lotteryDate];
            comps = [calendar components:(NSWeekdayCalendarUnit) fromDate:date];
            
            // 抽選曜日の月曜日か木曜日の場合
            if ([comps weekday] == 2 || [comps weekday] == 5) {
                times++;
                comps = [calendar components:(NSDayCalendarUnit) fromDate:lotteryNewestDate toDate:date options:0];
                //diffDay = [comps day];
                if ([comps day] >= 0) {
                    NSLog(@"直近の回数 %d", times);
                    break;
                }
            }
            
            diffDay++;
        }
    }

    if (diffDay == 0) {
        // 最新の情報が取得されている場合はsqlite3から過去10回の情報を取得する
    }
    else {
        // 最新の情報が取得できない場合は計算して過去10回の情報を取得する
        diffDay = -1; // 直近の抽選日は取得できているので、含めない
        cnt = 0;
        // 過去の日付10個（直近を除いて9個）
        while (1==1) {
            date = [NSDate dateWithTimeInterval:diffDay*24*60*60 sinceDate:lotteryNewestDate];
            comps = [calendar components:(NSWeekdayCalendarUnit)
                                fromDate:date];
            
            // 抽選曜日の月曜日か木曜日の場合
            if ([comps weekday] == 2 || [comps weekday] == 5) {
                NSLog(@"過去 CALC %02d 抽選日 %@", cnt, [outputDateFormatter stringFromDate:date]);
                cnt++;
            }
            
            diffDay--;

            if (cnt >= 9) {
                break;
            }
        }
        
        // 未来の日付 5個
        diffDay = 1;
        cnt = 0;
        while (1==1) {
            date = [NSDate dateWithTimeIntervalSinceNow:diffDay*24*60*60];
            comps = [calendar components:(NSWeekdayCalendarUnit)
                                fromDate:date];
            // 抽選曜日の月曜日か木曜日の場合
            if ([comps weekday] == 2 || [comps weekday] == 5) {
                NSLog(@"未来 CALC %02d 抽選日 %@", cnt, [outputDateFormatter stringFromDate:date]);
                cnt++;
            }
            
            diffDay++;
            
            if (cnt >= 5) {
                break;
            }
        }
    }
    
    // 回数を元に当日の回数を割り出す
    
    // 当日から未来の抽選日・回数（５つ）、過去の抽選日・回数（１０個）を取得する
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
