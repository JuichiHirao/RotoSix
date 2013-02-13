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
            lottery.sales = [rs intForColumn:@"sales"];
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

+(NSMutableArray *)getSearchNumSet:(NSString *) numset {
    
    if ([numset length] <= 0) {
        NSLog(@"getSearchNumSet nameset is not set");
        return nil;
    }
    
    NSLog(@"getSearchNumSet nameset %@", numset);
    NSMutableArray *listLottery = [[NSMutableArray alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getMasterFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];

        NSString *workNumSet = [numset stringByReplacingOccurrencesOfString:@"," withString:@"%"];
        NSString *paramNumSet = [NSString stringWithFormat:@"%%%@%%", workNumSet];
        NSLog(@"paramNumSet %@", paramNumSet);
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, lottery_date, times, num_set,one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover FROM lottery WHERE num_set like ?", paramNumSet];

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
            lottery.sales = [rs intForColumn:@"sales"];
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

// SBJSONを使用して、取得した１件分の当選データ（NSDictionary）からLotteryを生成する
+ (Lottery *)getDataFromJson:(NSDictionary *)dict {
    Lottery *lottery = [[Lottery alloc]init];
    NSLog(@"times %@", [dict objectForKey:@"times"]);

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
//    lottery.sales = [rs longForColumn:@"sales"];
    lottery.carryover = [(NSString*)[dict objectForKey:@"carryover"] intValue];

    return lottery;
}

@end
