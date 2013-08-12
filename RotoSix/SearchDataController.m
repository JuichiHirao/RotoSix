//
//  SearchDataController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/14.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import "SearchDataController.h"
#import "Search.h"
#import "FMDatabase.h"
#import "DatabaseFileController.h"

@implementation SearchDataController

@synthesize list;

-(id)init {
    if (self = [super init]) {
        [self load];
    }
    return self;
}

- (unsigned)countOfList {
    return [list count];
}

- (Search *)objectInListAtIndex:(unsigned)theIndex {
    if ([list count] <= 0) {
        return nil;
    }
    return [list objectAtIndex:theIndex];
}

- (void)removeObjectInListAtIndex:(unsigned)theIndex {
    Search *search = [list objectAtIndex:theIndex];
    [search remove];

    [list removeObjectAtIndex:theIndex];
}

-(void)load {
    
    NSMutableArray *listSearch = [[NSMutableArray alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:[DatabaseFileController getTranFile]];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
/*
        for (NSString* tableName in tables) {
            if (![db tableExists:tableName]) {
                if (![db executeUpdate:[tables objectForKey:tableName], nil]) {
                    NSLog(@"ERROR: %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                }
            }
        }
 */
        FMResultSet *rs = [db executeQuery:@"SELECT id, num_set, regist_date, match_count, total_amount, best_lottery FROM search order by regist_date desc"];
        
        if (db.lastErrorCode > 0) {
            NSString *msg = db.lastErrorMessage;
            NSLog(@"db.lastErrorCode %d  [%@]", db.lastErrorCode, db.lastErrorMessage);
            if ([msg isEqualToString:@"no such table: search"] == YES) {
                [db executeUpdate:@"create table search(id integer primary key autoincrement, num_set text, regist_date date, match_count integer)"];
                NSLog(@"db.lastErrorCode %d  [%@]", db.lastErrorCode, db.lastErrorMessage);
                
                rs = [db executeQuery:@"SELECT id, num_set, regist_date, match_count, total_amount, best_lottery FROM search order by regist_date desc"];
            }
            if ([msg isEqualToString:@"no such column: total_amount"] == YES) {
                [db executeUpdate:@"alter table search add column total_amount integer"];
                NSLog(@"db.lastErrorCode %d  [%@]", db.lastErrorCode, db.lastErrorMessage);
                [db executeUpdate:@"alter table search add column best_lottery integer"];
                NSLog(@"db.lastErrorCode %d  [%@]", db.lastErrorCode, db.lastErrorMessage);
                [db executeUpdate:@"vacuum"];
                NSLog(@"db.lastErrorCode %d  [%@]", db.lastErrorCode, db.lastErrorMessage);
                
                rs = [db executeQuery:@"SELECT id, num_set, regist_date, match_count, total_amount, best_lottery FROM search order by regist_date desc"];
            }
        }

        while ([rs next]) {
            Search *search;
            
            search = [[Search alloc]init];
            search.dbId = [rs intForColumn:@"id"];
            search.num_set = [rs stringForColumn:@"num_set"];
            search.registDate = [rs dateForColumn:@"regist_date"];
            search.matchCount = [rs intForColumn:@"match_count"];
            search.totalAmount = [rs intForColumn:@"total_amount"];
            search.bestLottery = [rs intForColumn:@"best_lottery"];
            
            [listSearch addObject:search];
            
            //ここでデータを展開
            NSLog(@"%d %@ %@ %d", search.dbId, search.num_set, search.registDate, search.matchCount);
        }
        [rs close];
        [db close];
        
        list = listSearch;
    }else{
        //DBが開けなかったらここ
    }    
}

@end
