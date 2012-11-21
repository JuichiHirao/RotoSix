//
//  BuyHistory.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistory.h"
#import "FMDatabase.h"

@implementation BuyHistory

@synthesize dbId, isDbUpdate, set01, set02, set03, set04, set05, lotteryTimes, lotteryDate, unit, prizeMoney, isSet01Update, isSet02Update, isSet03Update, isSet04Update, isSet05Update;

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

-(void)save {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];

        [db beginTransaction];
        
        // IDが0以上で設定されている場合は、更新
        if (dbId > 0) {
            for (int idx=0; idx < 5; idx++) {
                
                if ([self isUpdate:idx]) {
                    //                NSString *strSql = [NSString stringWithFormat:@"UPDATE buy_history set set%02d = ?  WHERE id = ? [dbId:%d]", idx+1, dbId];
                    NSString *strSql = [NSString stringWithFormat:@"UPDATE buy_history set set%02d = ?  WHERE id = ?", idx+1];
                    NSLog(@"UPDATE buy_history set set%02d = ? [set%02d:%@]  WHERE id = ? [dbId:%d] ", idx+1, idx+1, [self getSetNo:idx], dbId);
                    
                    [db executeUpdate:strSql, [self getSetNo:idx], [NSNumber numberWithInteger:dbId]];
                }
            }
        }
        // IDが0の場合は挿入
        else {
            NSString *strSql = [NSString stringWithFormat:@"INSERT INTO buy_history ( "
                                @"lottery_times, set01, set02, set03, set04, set05, lottery_amount"
                                @", lottery_date ) VALUES( ?, ?, ?, ?, ?, ?, ?, ?)"];
            
            [db executeUpdate:strSql
                ,[NSNumber numberWithInteger:lotteryTimes]
                , set01, set02, set03, set04, set05
                , prizeMoney, lotteryDate];
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

-(void)remove {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
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
