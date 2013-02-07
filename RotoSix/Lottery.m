//
//  Lottery.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/01.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "Lottery.h"
#import "FMDatabase.h"
#import "DatabaseFileController.h"

@implementation Lottery

@synthesize dbId, lotteryDate, times, num_set, one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover;

- (NSComparisonResult)compareTimes:(Lottery *)data {
    if (self.times > data.times) {
        return NSOrderedDescending;
    }
    else if (self.times < data.times) {
        return NSOrderedAscending;
    }
    else {
        return NSOrderedSame;
    }
}

-(void)save {
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getMasterFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        
        // IDが0以上で設定されている場合は、更新
        if (dbId > 0) {
            NSString *strSql = [NSString stringWithFormat:
                                @"UPDATE lottery set set%02d = ? "
                                @"  SET lottery_date = ? "
                                @"    , times = ?"
                                @"    , num_set = ?"
                                @"    , one_unit = ?"
                                @"    , one_amount = ?"
                                @"    , two_unit = ?"
                                @"    , two_amount = ?"
                                @"    , three_unit = ?"
                                @"    , three_amount = ?"
                                @"    , four_unit = ?"
                                @"    , four_amount = ?"
                                @"    , five_unit = ?"
                                @"    , five_amount = ?"
                                @"    , sales = ?"
                                @"    , carryover = ?"
                                @" WHERE id = ? "
                                , dbId];
            NSLog(@"%@", strSql);
                    
            [db executeUpdate:strSql,[NSNumber numberWithInteger:dbId]];
        }
        // IDが0の場合は挿入
        else {
            NSString *strSql = [NSString stringWithFormat:@"INSERT INTO lottery ( "
                                @"lottery_date, times, num_set, one_unit, one_amount, two_unit, two_amount, three_unit, three_amount "
                                @", four_unit, four_amount, five_unit, five_amount, sales, carryover "
                                @") VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
            
            [db executeUpdate:strSql
             , lotteryDate
             ,[NSNumber numberWithInteger:times]
             , num_set
             ,[NSNumber numberWithInteger:one_unit], [NSNumber numberWithInteger:one_amount]
             ,[NSNumber numberWithInteger:two_unit], [NSNumber numberWithInteger:two_amount]
             ,[NSNumber numberWithInteger:three_unit], [NSNumber numberWithInteger:three_amount]
             ,[NSNumber numberWithInteger:four_unit], [NSNumber numberWithInteger:four_amount]
             ,[NSNumber numberWithInteger:five_unit], [NSNumber numberWithInteger:five_amount]
             , sales, carryover]; 
        }
        
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            [db rollback];
        }
        else {
            [db commit];
        }
        
        [db close];
        
    }else{
        //DBが開けなかったらここ
    }
}


@end
