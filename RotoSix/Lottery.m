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

@synthesize dbId, lotteryDate, times, num_set, one_unit, one_amount, two_unit, two_amount, three_unit, three_amount, four_unit, four_amount, five_unit, five_amount, sales, carryover, lotteryRanking;

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

// 使用しないが参考のために保存
- (NSString *)getCammaSales {
    //NSString *data = [NSString stringWithFormat:@"%lld", sales];
    NSMutableString *data = [NSMutableString string];
    NSString *work = @"";
    
    NSInteger amr = data.length % 3;
    NSInteger wr = (data.length - amr) / 3;
    
    NSString *piyo = [data substringWithRange:NSMakeRange(0, amr)];
    
    for (int idx=0; idx < wr; idx++) {
        [work stringByAppendingString:piyo];
        [work stringByAppendingString:@","];
    }

    long long int l = sales;
    
    int d = 0;
	int n, a;
	do {
		// 3桁毎をチェックしてカンマ挿入
		if (d == 3) {
//			s = ',' + s;
            // data = [data stringByAppendingString:@","];
            [data insertString:@"," atIndex:0];
			d = 0;
		}
		d ++;
        
		// 　下一桁をバッファの先頭に追加
		n = l%10;
        a = '0' + n;
        //data = [data stringByAppendingFormat:@"%c", a];
        [data insertString:[NSString stringWithFormat:@"%c", a] atIndex:0];
//		s = char('0'+(n)) + s;
        
		// 　数値を1桁シフト(下一桁を取り除く)
		l /= 10;
	} while (l > 0);
    
	//return s;
    
	return data;

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
