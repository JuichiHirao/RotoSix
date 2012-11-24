//
//  DatabaseFileController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/22.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "DatabaseFileController.h"

@implementation DatabaseFileController

+ (NSString *)getMasterFile {
    
    NSString *dbmstPath = @"";
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    dbmstPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", dbmstPath]);

    // 存在しない場合はProject内のファイルをコピーして初期状態にする
    BOOL result_flag = [fm fileExistsAtPath:dbmstPath];
    if(!result_flag){
        [self clearMasterFile];
        
        dbmstPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    }
    
    return dbmstPath;
}

+ (void)clearMasterFile {
    //呼び出したいメソッドで下記を実行
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", writableDBPath]);
    
    BOOL result_flag = [fm fileExistsAtPath:writableDBPath];
    if(result_flag){
        [fm removeItemAtPath:writableDBPath error:nil];
    }
    
    // Project内のファイルをコピーしてクリア
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"defaultDBPath [%@]", defaultDBPath]);
    
    BOOL copy_result_flag = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if(!copy_result_flag){
        //失敗したらここ
        NSLog(@"%@", [NSString stringWithFormat:@"copy failed"]);
    }
}

+ (NSString *)getTranFile {
    
    NSString *dbtrPath = @"";
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    dbtrPath = [documentsDirectory stringByAppendingPathComponent:@"tr.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", dbtrPath]);
    
    // 存在しない場合はProject内のファイルをコピーして初期状態にする
    BOOL result_flag = [fm fileExistsAtPath:dbtrPath];
    if(!result_flag){
        [self clearTranFile];
        
        dbtrPath = [documentsDirectory stringByAppendingPathComponent:@"tr.db"];
    }
    
    return dbtrPath;
}

+ (void)clearTranFile {
    //呼び出したいメソッドで下記を実行
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"tr.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", writableDBPath]);
    
    BOOL result_flag = [fm fileExistsAtPath:writableDBPath];
    if(result_flag){
        [fm removeItemAtPath:writableDBPath error:nil];
    }
    
    // Project内のファイルをコピーしてクリア
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tr.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"defaultDBPath [%@]", defaultDBPath]);
    
    BOOL copy_result_flag = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if(!copy_result_flag){
        //失敗したらここ
        NSLog(@"%@", [NSString stringWithFormat:@"copy failed [%@]", error]);
    }
}

-(void)createDemoFromDb {
    //呼び出したいメソッドで下記を実行
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"writableDBPath [%@]", writableDBPath]);
    
    BOOL result_flag = [fm fileExistsAtPath:writableDBPath];
    if(result_flag){
        [fm removeItemAtPath:writableDBPath error:nil];
    }
    
    //dbが存在してなかったらここが呼ばれて、作成したDBをコピー
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mst.db"];
    NSLog(@"%@", [NSString stringWithFormat:@"defaultDBPath [%@]", defaultDBPath]);
    
    BOOL copy_result_flag = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if(!copy_result_flag){
        //失敗したらここ
        NSLog(@"%@", [NSString stringWithFormat:@"copy failed"]);
    }
}

@end
