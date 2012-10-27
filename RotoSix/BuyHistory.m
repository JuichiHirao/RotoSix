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

@synthesize set01, set02, set03, set04, set05, lotteryNo, lotteryDate, unit, prizeMoney, isSet01Update, isSet02Update, isSet03Update, isSet04Update, isSet05Update;

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
-(void) setUpdate:(NSInteger)selBuyNo {
    if (selBuyNo==0) {
        self.isSet01Update = 1;
    }
    else if (selBuyNo==1) {
        self.isSet02Update = 1;
    }
        else if (selBuyNo==2) {
        self.isSet03Update = 1;
    }
    else if (selBuyNo==3) {
        self.isSet04Update = 1;
    }
    else if (selBuyNo==4) {
        self.isSet05Update = 1;
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
    //呼び出したいメソッドで下記を実行
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", writableDBPath]);
    
    BOOL result_flag = [fm fileExistsAtPath:writableDBPath];
    if(!result_flag){
        //dbが存在してなかったらここが呼ばれて、作成したDBをコピー
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mst.db"];
        NSLog(@"%@", [NSString stringWithFormat:@"defaultDBPath [%@]", defaultDBPath]);
        
        BOOL copy_result_flag = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if(!copy_result_flag){
            //失敗したらここ
            NSLog(@"%@", [NSString stringWithFormat:@"copy failed"]);
        }
    }
    
    NSMutableArray *listBuyHist = [[NSMutableArray alloc] init];
    
    //作成したテーブルからデータを取得
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        FMResultSet *rs = [db executeQuery:@"SELECT lottery_no, set01, set02, set03, set04, set05, lottery_amount, lottery_date FROM buy_history order by lottery_no desc"];
        while ([rs next]) {
            BuyHistory *buyHist;
            
            buyHist = [[BuyHistory alloc]init];
            buyHist.set01 = [rs stringForColumn:@"set01"];
            buyHist.set02 = [rs stringForColumn:@"set02"];
            buyHist.set03 = [rs stringForColumn:@"set03"];
            buyHist.set04 = [rs stringForColumn:@"set04"];
            buyHist.set05 = [rs stringForColumn:@"set05"];
            buyHist.lotteryDate = [rs dateForColumn:@"lottery_date"];
            //            buyHist.unit = 2;
            //            buyHist.lotteryDate = [dateFormatter dateFromString:@"20120601"];
            buyHist.lotteryNo = [rs intForColumn:@"lottery_no"];
            
            [listBuyHist addObject:buyHist];
            
            //ここでデータを展開
            NSLog(@"%d %@ %@ %@ %@ %@ %d %@", [rs intForColumn:@"lottery_no"], [rs stringForColumn:@"set01"]
                  , [rs stringForColumn:@"set02"], [rs stringForColumn:@"set03"], [rs stringForColumn:@"set04"]
                  , [rs stringForColumn:@"set05"], [rs intForColumn:@"lottery_amount"], [rs dateForColumn:@"lottery_date"]);
        }
        [rs close];
        [db close];
        
        //list = listBuyHist;
    }else{
        //DBが開けなかったらここ
    }    
}


@end
