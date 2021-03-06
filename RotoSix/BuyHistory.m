//
//  BuyHistory.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistory.h"
#import "FMDatabase.h"
#import "DatabaseFileController.h"
#import "Lottery.h"

@implementation BuyHistory

@synthesize dbId, isDbUpdate, set01, place01, set02, place02, set03, place03, set04, place04, set05, place05, lotteryTimes, lotteryDate, unit, lotteryStatus, prizeMoney, isSet01Update, isSet02Update, isSet03Update, isSet04Update, isSet05Update;

-(BOOL) isUpdate:(NSInteger)selBuyNo {
    if (selBuyNo==0) {
        if (self.isSet01Update==1) {
            return YES;
        }
    }
    else if (selBuyNo==1) {
        if (self.isSet02Update==1) {
            return YES;
        }
    }
    else if (selBuyNo==2) {
        if (self.isSet03Update==1) {
            return YES;
        }
    }
    else if (selBuyNo==3) {
        if (self.isSet04Update==1) {
            return YES;
        }
    }
    else if (selBuyNo==4) {
        if (self.isSet05Update==1) {
            return YES;
        }
    }
    return NO;
}

-(void) removeSetData:(NSInteger)setNoIndex {
    NSLog(@"removeSetData setNoIndx [%d]  getCount [%d]", setNoIndex, [self getCount]);
    // 最後の場合は削除するだけ
    if ([self getCount] == setNoIndex+1) {
        [self changeSetNo:setNoIndex SetNo:@""];
    }
    // 最後以外は削除してずらす
    else {
        int count = [self getCount];

        [self changeSetNo:setNoIndex SetNo:@""];
        int idx = 0;
        for (idx=setNoIndex+1; idx<count; idx++) {
            NSString *setno = [self getSetNo:idx];
            [self changeSetNo:idx-1 SetNo:setno];
            [self changeSetNo:idx SetNo:@""];
        }
    }
}

-(void) setUpdate:(NSInteger)selBuyNo Status:(NSInteger)status {
    if (selBuyNo==0) {
        self.isSet01Update = status;
    }
    else if (selBuyNo==1) {
        self.isSet02Update = status;
    }
        else if (selBuyNo==2) {
        self.isSet03Update = status;
    }
    else if (selBuyNo==3) {
        self.isSet04Update = status;
    }
    else if (selBuyNo==4) {
        self.isSet05Update = status;
    }
}

-(NSString*) getSetNo:(NSInteger)setNoIndex {
    if (setNoIndex==0) {
        return set01;
    }
    else if (setNoIndex==1) {
        return set02;
    }
    else if (setNoIndex==2) {
        return set03;
    }
    else if (setNoIndex==3) {
        return set04;
    }
    else if (setNoIndex==4){
        return set05;
    }
    
    return @"";
}

-(NSInteger) getPlace:(NSInteger)setNoIndex {
    if (setNoIndex==0) {
        return place01;
    }
    else if (setNoIndex==1) {
        return place02;
    }
    else if (setNoIndex==2) {
        return place03;
    }
    else if (setNoIndex==3) {
        return place04;
    }
    else if (setNoIndex==4){
        return place05;
    }
    
    return -1;
}

-(NSString*) changeSetNo:(NSInteger)setNoIndex SetNo:(NSString *)setNo {
    if (setNoIndex==0) {
        set01 = setNo;
    }
    else if (setNoIndex==1) {
        set02 = setNo;
    }
    else if (setNoIndex==2) {
        set03 = setNo;
    }
    else if (setNoIndex==3) {
        set04 = setNo;
    }
    else if (setNoIndex==4){
        set05 = setNo;
    }
    
    return @"";
}

-(NSInteger) getCount {
    if ([set01 length] == 0) {
        return 0;
    }
    else if ([set02 length] == 0) {
        return 1;
    }
    else if ([set03 length] == 0) {
        return 2;
    }
    else if ([set04 length] == 0) {
        return 3;
    }
    else if ([set05 length] == 0) {
        return 4;
    }
    else {
        return 5;
    }
}

-(void) lotteryCheck:(Lottery *) lottery {
    
    NSInteger place = 0;
    place = [self lotteryCheck:set01 Lottery:lottery];
    if (self.place01 != place) {
        [self setUpdate:0 Status:1];
        self.place01 = place;
    }
    place = [self lotteryCheck:set02 Lottery:lottery];
    if (self.place02 != place) {
        [self setUpdate:1 Status:1];
        self.place02 = place;
    }
    place = [self lotteryCheck:set03 Lottery:lottery];
    if (self.place03 != place) {
        [self setUpdate:2 Status:1];
        self.place03 = place;
    }
    place = [self lotteryCheck:set04 Lottery:lottery];
    if (self.place04 != place) {
        [self setUpdate:3 Status:1];
        self.place04 = place;
    }
    place = [self lotteryCheck:set05 Lottery:lottery];
    if (self.place05 != place) {
        [self setUpdate:4 Status:1];
        self.place05 = place;
    }
    
    self.lotteryStatus = 1;
    
    return;
}

-(NSInteger) lotteryCheck:(NSString *)setData Lottery:(Lottery *)lottery {
    
    NSInteger place = 0;
    NSArray *arrSelectNo = [setData componentsSeparatedByString:@","];
    bool isMatchBonus = NO;
    
    NSString *bonusNo = [lottery.num_set substringFromIndex:[lottery.num_set length]-2];
    
    int matchNo = 0;
    for (int idx=0; idx < [arrSelectNo count]; idx++) {
        NSString *data = [NSString stringWithFormat:@"%@,", arrSelectNo[idx]];
        
        if ([lottery.num_set rangeOfString:data].length > 0) {
            matchNo++;
        }
        
        if ([arrSelectNo[idx] isEqual:bonusNo] == YES) {
            isMatchBonus = YES;
        }
    }
    
    if (matchNo == 3)
        place = 5;
    else if (matchNo == 4) {
        place = 4;
    }
    else if (matchNo == 5 && isMatchBonus == NO) {
        place = 3;
    }
    else if (matchNo == 5 && isMatchBonus == YES) {
        place = 2;
    }
    else if (matchNo == 6) {
        place = 1;
    }

    NSLog(@"matchNo %d  bonusNo %@ place %d", matchNo, bonusNo, place);

    return place;
}

- (NSString *)getPlaceImageName:(NSInteger) place {
    //NSLog(@"getPlaceImageName place [%d] ", place);
    if (place == 1) {
        return @"Lottery-1st";
    }
    else if (place == 2) {
        return @"Lottery-2nd";
    }
    else if (place == 3) {
        return @"Lottery-3rd";
    }
    else if (place == 4) {
        return @"Lottery-4th";
    }
    else if (place == 5) {
        return @"Lottery-5th";
    }
    return @"Lottery-no";
}

// パラメータの文字列がNumSetのデータとして正しいかの検証をする
+(BOOL) validateNumSet:(NSString *)data {
    if (data.length != 17) {
        return FALSE;
    }
    
    NSArray *arrData = [data componentsSeparatedByString:@","];
    
    if ([arrData count] != 6) {
        return FALSE;
    }
    
    int val;
    for (int idx=0; idx < [arrData count]; idx++) {
        NSScanner* scan = [NSScanner scannerWithString:arrData[idx]];
        if ([scan scanInt:&val] == FALSE)
            return FALSE;
    }

    return TRUE;
}

// sqliteのデータベースから情報を再取得する
//   detail画面から更新してdetail画面へ戻った場合に更新ステータス更新が戻らない現象の解消のため
-(void)reload {
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getTranFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT lottery_times, set01, place01, set02, place02, set03, place03, set04, place04, set05, place05, lottery_status, lottery_date FROM buy_history WHERE id = ?", [NSNumber numberWithInteger:dbId]];
        
        if ([db hadError]) {
            NSLog(@"BuyHistroy.reload Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            return;
        }
        
        while ([rs next]) {
            lotteryTimes = [rs intForColumn:@"lottery_times"];
            set01 = [rs stringForColumn:@"set01"];
            place01 = [rs intForColumn:@"place01"];
            set02 = [rs stringForColumn:@"set02"];
            place02 = [rs intForColumn:@"place02"];
            set03 = [rs stringForColumn:@"set03"];
            place03 = [rs intForColumn:@"place03"];
            set04 = [rs stringForColumn:@"set04"];
            place04 = [rs intForColumn:@"place04"];
            set05 = [rs stringForColumn:@"set05"];
            place05 = [rs intForColumn:@"place05"];
            lotteryStatus = [rs intForColumn:@"lottery_status"];
            lotteryDate = [rs dateForColumn:@"lottery_date"];
            
            isDbUpdate = 0;
            isSet01Update = 0;
            isSet02Update = 0;
            isSet03Update = 0;
            isSet04Update = 0;
            isSet05Update = 0;
            //ここでデータを展開
            //NSLog(@"%d 01[%@] 02[%@] 03[%@] 04[%@] 05[%@]", buyHist.dbId, [rs stringForColumn:@"set01"]
            //      , [rs stringForColumn:@"set02"], [rs stringForColumn:@"set03"], [rs stringForColumn:@"set04"]
            //      , [rs stringForColumn:@"set05"]);
        }
        [rs close];
        [db close];
    }else{
        //DBが開けなかったらここ
    }    
}

-(void)save {
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getTranFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];

        [db beginTransaction];
        
        // IDが0以上で設定されている場合は、更新
        if (dbId > 0) {
            for (int idx=0; idx < 5; idx++) {
                
                if ([self isUpdate:idx]) {
                    //                NSString *strSql = [NSString stringWithFormat:@"UPDATE buy_history set set%02d = ?  WHERE id = ? [dbId:%d]", idx+1, dbId];
                    NSString *strSql = [NSString stringWithFormat:@"UPDATE buy_history set set%02d = ?, place%02d = ? WHERE id = ?", idx+1, idx+1];
                    //NSLog(@"UPDATE buy_history set set%02d = ? [set%02d:%@], place%02d = ? [%d] WHERE id = ? [dbId:%d] ", idx+1, idx+1, [self getSetNo:idx], idx+1, [self getPlace:idx], dbId);
                    
                    [db executeUpdate:strSql, [self getSetNo:idx], [NSNumber numberWithInteger:[self getPlace:idx]], [NSNumber numberWithInteger:dbId]];
                    
                    if ([db hadError]) {
                        NSLog(@"BuyHistroy.save update Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                        [db rollback];
                        [db close];
                        return;
                    }
                }
            }
            NSString *strSql = @"UPDATE buy_history set lottery_status = ? WHERE id = ? ";
            NSLog(@"UPDATE buy_history set lottery_status = ? [%d] WHERE id = ? [dbId:%d] ", lotteryStatus, dbId);
            
            [db executeUpdate:strSql, [NSNumber numberWithInteger:lotteryStatus], [NSNumber numberWithInteger:dbId]];
            
            if ([db hadError]) {
                NSLog(@"BuyHistroy.save update Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                [db rollback];
                [db close];
                return;
            }
        }
        // IDが0の場合は挿入
        else {
            NSString *strSql = [NSString stringWithFormat:@"INSERT INTO buy_history ( "
                                @"lottery_times, set01, set02, set03, set04, set05, lottery_status"
                                @", lottery_date ) VALUES( ?, ?, ?, ?, ?, ?, ?, ?)"];
            
            [db executeUpdate:strSql
                ,[NSNumber numberWithInteger:lotteryTimes]
                , set01, set02, set03, set04, set05
                , [NSNumber numberWithInteger:lotteryStatus], lotteryDate];
        }

        if ([db hadError]) {
            NSLog(@"BuyHistroy.save insert Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            [db rollback];
        }
        else {
            isSet01Update = 0;
            isSet02Update = 0;
            isSet03Update = 0;
            isSet04Update = 0;
            isSet05Update = 0;
            isDbUpdate = 0;
            [db commit];
        }

        [db close];
        
    }else{
        //DBが開けなかったらここ
    }
}

-(void)remove {
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getTranFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        
        NSString *strSql = [NSString stringWithFormat:@"DELETE FROM buy_history WHERE id = ?"];
        NSLog(@"DELETE FROM buy_history WHERE id = %d", dbId);
        
        [db executeUpdate:strSql, [NSNumber numberWithInteger:dbId]];
        
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
