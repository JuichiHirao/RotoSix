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
#import "DatabaseFileController.h"

@interface LotteryDataController()
@property (nonatomic, copy, readwrite) NSMutableArray *list;

@end

@implementation LotteryDataController

@synthesize dbmstPath;
@synthesize list;

- (unsigned)countOfList {
    return [list count];
}

- (Lottery *)objectInListAtIndex:(unsigned)theIndex {
    return [list objectAtIndex:theIndex];
}

-(void)createDemoFromDb {

    NSMutableArray *listLottery = [[NSMutableArray alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getMasterFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set, one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM lottery order by times desc"];
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
            lottery.sales = [rs longLongIntForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
            
            [listLottery addObject:lottery];
            
            //ここでデータを展開
            NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %ld %d"
                  , lottery.dbId, lottery.lotteryDate, lottery.times
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

    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getMasterFile]];
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
            lottery.sales = [rs longLongIntForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
                        
            //ここでデータを展開
            NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %lld %d", lottery.dbId, lottery.lotteryDate, lottery.times
                  , lottery.num_set, lottery.one_unit, lottery.one_amount, lottery.two_unit, lottery.two_amount
                  , lottery.three_unit, lottery.three_amount, lottery.four_unit, lottery.four_amount
                  , lottery.five_unit, lottery.five_amount, lottery.sales, lottery.carryover);
            cnt++;
        }
        if (cnt<=0) {
            NSLog(@"lottery NO DATA!! [%d]", times);
        }
        [rs close];
        [db close];
        
    }else{
        //DBが開けなかったらここ
    }
    return lottery;
}

+(NSMutableArray *)addArraySearchNumSet:(NSString *) numset DestArray:(NSMutableArray *)arrDest LotteryRanking:(NSInteger) lotteryRanking {
    
    NSMutableArray *arrDb = [LotteryDataController getSearchNumSet:numset];
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    
    if ([arrDb count] > 0) {
        bool isSame = NO;
        for (int idx=0; idx < [arrDb count]; idx++) {
            Lottery *data = arrDb[idx];
            
            for (int idxDest=0; idxDest < [arrDest count]; idxDest++) {
                Lottery *dataDest = arrDest[idxDest];
                
                if (data.times == dataDest.times) {
                    isSame = YES;
                    break;
                }
            }
            
            if (isSame == NO) {
                if (lotteryRanking > 0) {
                    data.lotteryRanking = lotteryRanking;
                }
                [arrData addObject:data];
            }
        }
    }
    
    if ([arrData count] > 0) {
        [arrDest addObjectsFromArray:arrData];        
    }
    
    return arrDest;
}

+(NSMutableArray *)getSearchNumSetAll:(NSString *) numset {

    if ([numset length] <= 0) {
        NSLog(@"getSearchNumSet nameset is not set");
        return nil;
    }
    
    NSArray *arrData = [numset componentsSeparatedByString:@","];
    
    int no = 1;
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSMutableArray *arrWork;
    
    // 数の多い順に配列を生成して、少ない個数の一致データと回数で突き合わせ、同じ回数の場合は配列へ設定しない
    // 6個（1等）
    if ([arrData count] >= 6) {
        NSString *data1tou = @"";
        for (int idxMain=0; idxMain<[arrData count]; idxMain++) {
            data1tou = [NSString stringWithFormat:@"%@%%%@", data1tou, arrData[idxMain]];
            
        }
        data1tou = [NSString stringWithFormat:@"%%%@,%%", data1tou];
        
        arrResult = [LotteryDataController addArraySearchNumSet:data1tou DestArray:arrResult LotteryRanking:1];
        arrWork = [LotteryDataController getSearchNumSet:data1tou];
        
        NSLog(@"data 1等 %03d %@ match [%d] Total [%d]", no, data1tou, [arrWork count], [arrResult count]);
        no++;
    }
    
    if ([arrData count] >= 5) {
        // 5個+BONUS（2等）
        for (int idxMain=[arrData count]-1; idxMain >= 0; idxMain--) {
            NSString *data = @"";
            for (int idxSub=0; idxSub < [arrData count]; idxSub++) {
                if (idxMain == idxSub) {
                    continue;
                }
                else {
                    NSString *dataSub = [NSString stringWithFormat:@"%%%@", arrData[idxSub]];
                    data = [data stringByAppendingString:dataSub];
                }
            }
            data = [NSString stringWithFormat:@"%@,%%%@", data, arrData[idxMain]];
            
            arrResult = [LotteryDataController addArraySearchNumSet:data DestArray:arrResult LotteryRanking:2];
            arrWork = [LotteryDataController getSearchNumSet:data];
            
            NSLog(@"data 2等 %03d %@   match [%d] Total [%d]", no, data, [arrWork count], [arrResult count]);
            no++;
        }
        
        // 5個（3等）
        for (int idxMain=[arrData count]-1; idxMain >= 0; idxMain--) {
            NSString *data = @"";
            for (int idxSub=0; idxSub < [arrData count]; idxSub++) {
                if (idxMain == idxSub) {
                    continue;
                }
                else {
                    NSString *dataSub = [NSString stringWithFormat:@"%%%@", arrData[idxSub]];
                    data = [data stringByAppendingString:dataSub];
                }
            }
            data = [NSString stringWithFormat:@"%@,%%", data];
            
            arrResult = [LotteryDataController addArraySearchNumSet:data DestArray:arrResult LotteryRanking:3];
            arrWork = [LotteryDataController getSearchNumSet:data];
            
            NSLog(@"data 3等 %03d %@     match [%d] Total [%d]", no, data, [arrWork count], [arrResult count]);
            no++;
        }
    }
    
    if ([arrData count] >= 4) {
        // 4個（4等）
        for (int idxMain=0; idxMain < [arrData count]; idxMain++) {
            NSString *data = arrData[idxMain];
            for (int idxSub=idxMain+1; idxSub < [arrData count]; idxSub++) {
                NSString *dataSub = [NSString stringWithFormat:@"%@%%%@", data, arrData[idxSub]];
                for (int idxSub2=idxSub+1; idxSub2 < [arrData count]; idxSub2++) {
                    NSString *dataSub2 = [NSString stringWithFormat:@"%@%%%@", dataSub, arrData[idxSub2]];
                    for (int idxSub3=idxSub2+1; idxSub3 < [arrData count]; idxSub3++) {
                        NSString *dataSub3 = [NSString stringWithFormat:@"%@%%%@", dataSub2, arrData[idxSub3]];
                        NSString *dataWhereLike = [NSString stringWithFormat:@"%%%@,%%", dataSub3];
                        
                        arrResult = [LotteryDataController addArraySearchNumSet:dataWhereLike DestArray:arrResult LotteryRanking:4];
                        arrWork = [LotteryDataController getSearchNumSet:dataWhereLike];
                        
                        NSLog(@"data 4等 %03d %@        match [%d] Total [%d]", no, dataWhereLike, [arrWork count], [arrResult count]);
                        no++;
                    }
                }
            }
        }
        
        // 3個（5等）
        for (int idxMain=0; idxMain < [arrData count]; idxMain++) {
            NSString *data = arrData[idxMain];
            for (int idxSub=idxMain+1; idxSub < [arrData count]; idxSub++) {
                NSString *dataSub = [NSString stringWithFormat:@"%@%%%@", data, arrData[idxSub]];
                for (int idxSub2=idxSub+1; idxSub2 < [arrData count]; idxSub2++) {
                    NSString *dataSub2 = [NSString stringWithFormat:@"%@%%%@", dataSub, arrData[idxSub2]];
                    NSString *dataWhereLike = [NSString stringWithFormat:@"%%%@,%%", dataSub2];
                    
                    arrResult = [LotteryDataController addArraySearchNumSet:dataWhereLike DestArray:arrResult LotteryRanking:5];
                    arrWork = [LotteryDataController getSearchNumSet:dataWhereLike];
                    
                    NSLog(@"data 5等 %03d %@           match [%d] Total [%d]", no, dataWhereLike, [arrWork count], [arrResult count]);
                    no++;
                }
            }
        }
    }
    
    return arrResult;
}

+(NSMutableArray *)getSearchNumSet:(NSString *) numset {
    
    if ([numset length] <= 0) {
        NSLog(@"getSearchNumSet nameset is not set");
        return nil;
    }
    
    //NSLog(@"getSearchNumSet nameset %@", numset);
    NSMutableArray *listLottery = [[NSMutableArray alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getMasterFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];

//        NSString *workNumSet = [numset stringByReplacingOccurrencesOfString:@"," withString:@"%"];
//        NSString *paramNumSet = [NSString stringWithFormat:@"%%%@%%", workNumSet];
        //NSLog(@"paramNumSet %@", paramNumSet);
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set,one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM lottery WHERE num_set like ?", numset];

//        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set, one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM lottery order by times desc"];
        
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
            lottery.sales = [rs longLongIntForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
            
            [listLottery addObject:lottery];
            
            //ここでデータを展開
//            NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %ld %d"
//                  , lottery.dbId, lottery.lotteryDate, lottery.times
//                  , lottery.num_set, lottery.one_unit, lottery.one_amount, lottery.two_unit, lottery.two_amount
//                  , lottery.three_unit, lottery.three_amount, lottery.four_unit, lottery.four_amount
//                  , lottery.five_unit, lottery.five_amount, lottery.sales, lottery.carryover);
        }
        [rs close];
        [db close];
    }else{
        //DBが開けなかったらここ
    }
    
    return listLottery;
}

+(NSMutableArray *)getPast:(NSInteger *)times MaxRow:(NSInteger)maxrow {
    
    //NSLog(@"getSearchNumSet nameset %@", numset);
    NSMutableArray *listLottery = [[NSMutableArray alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getMasterFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set,one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM lottery WHERE times < ? ORDER BY times DESC ", [NSNumber numberWithInteger:times]];
        
        int cnt = 0;
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
            lottery.sales = [rs longLongIntForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
            
            [listLottery addObject:lottery];
            
            cnt++;
            
            if (maxrow <= cnt) {
                break;
            }
            
            //ここでデータを展開
//            NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %ld %d"
//                  , lottery.dbId, lottery.lotteryDate, lottery.times
//                  , lottery.num_set, lottery.one_unit, lottery.one_amount, lottery.two_unit, lottery.two_amount
//                  , lottery.three_unit, lottery.three_amount, lottery.four_unit, lottery.four_amount
//                  , lottery.five_unit, lottery.five_amount, lottery.sales, lottery.carryover);
        }
        [rs close];
        [db close];
    }else{
        //DBが開けなかったらここ
    }
    
    return listLottery;
}


+(Lottery *)getSearchNumSetOnlyFirstRow:(NSString *) numset {
    
    Lottery *lottery;
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getMasterFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        NSString *paramNumSet = [NSString stringWithFormat:@"%@%%", numset];
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set,one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM lottery WHERE num_set like ?", paramNumSet];
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
            lottery.sales = [rs longLongIntForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
            
            //ここでデータを展開
            NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %lld %d", lottery.dbId, lottery.lotteryDate, lottery.times
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
    
    Lottery *lottery = [[Lottery alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getMasterFile]];
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
            lottery.sales = [rs longLongIntForColumn:@"sales"];
            lottery.carryover = [rs intForColumn:@"carryover"];
        }

        //ここでデータを展開
        NSLog(@"%d %@ %d %@ one %d %d two %d %d three %d %d four %d %d five %d %d   %lld %d", lottery.dbId, lottery.lotteryDate, lottery.times
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

// SBJSONを使用して、取得した１件分の当選データ（NSDictionary）からLotteryを生成する
+ (Lottery *)getDataFromJson:(NSDictionary *)dict {
    Lottery *lottery = [[Lottery alloc]init];
    //NSLog(@"times %@", [dict objectForKey:@"times"]);

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate *formatterDate = [inputFormatter dateFromString:(NSString*)[dict objectForKey:@"num_set"]];
    
    NSString *data = (NSString*)[dict objectForKey:@"lottery_date"];
    lottery.lotteryDate = [inputFormatter dateFromString:data];
    lottery.times = [(NSString*)[dict objectForKey:@"times"] intValue];
    NSString *num_set = (NSString*)dict[@"num_set"];
    lottery.num_set = num_set;
    lottery.one_unit = [(NSString*)[dict objectForKey:@"one_unit"] intValue];
    lottery.one_amount = [(NSString*)[dict objectForKey:@"one_amount"] intValue];
    lottery.two_unit = [(NSString*)[dict objectForKey:@"two_unit"] intValue];
    lottery.two_amount = [(NSString*)[dict objectForKey:@"two_amount"] intValue];
    lottery.three_unit = [(NSString*)[dict objectForKey:@"three_unit"] intValue];
    lottery.three_amount = [(NSString*)[dict objectForKey:@"three_amount"] intValue];
    lottery.four_unit = [(NSString*)[dict objectForKey:@"four_unit"] intValue];
    lottery.four_amount = [(NSString*)[dict objectForKey:@"four_unit"] intValue];
    lottery.five_unit = [(NSString*)[dict objectForKey:@"five_unit"] intValue];
    lottery.five_amount = [(NSString*)[dict objectForKey:@"five_amount"] intValue];
    lottery.sales = [(NSString*)[dict objectForKey:@"sales"] longLongValue];
    lottery.carryover = [(NSString*)[dict objectForKey:@"carryover"] intValue];

    return lottery;
}

@end
