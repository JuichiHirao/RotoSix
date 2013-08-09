//
//  Search.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/14.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import "Search.h"
#import "FMDatabase.h"
#import "DatabaseFileController.h"

@implementation Search

@synthesize dbId, num_set, registDate, matchCount;

-(void)save {
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getTranFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        
        // IDが0以上で設定されている場合は、更新
        if (dbId > 0) {
            NSString *strSql = [NSString stringWithFormat:@"UPDATE search SET num_set = ?, regist_date = ?, match_count = ?  WHERE id = ?"];
//          NSLog(@"UPDATE buy_history set set%02d = ? [set%02d:%@]  WHERE id = ? [dbId:%d] ", idx+1, idx+1, [self getSetNo:idx], dbId);
                    
            [db executeUpdate:strSql, num_set, registDate
             ,[NSNumber numberWithInteger:matchCount], [NSNumber numberWithInteger:dbId]];
        }
        // IDが0の場合は挿入
        else {
            NSString *strSql = [NSString stringWithFormat:@"INSERT INTO search ( "
                                @"num_set, regist_date, match_count"
                                @" ) VALUES(?, ?, ?)"];

            [db executeUpdate:strSql
             , num_set, registDate
             ,[NSNumber numberWithInteger:matchCount]];
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
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getTranFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        
        NSString *strSql = [NSString stringWithFormat:@"DELETE FROM search WHERE id = ?"];
        NSLog(@"DELETE FROM search WHERE id = %d", dbId);
        
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
