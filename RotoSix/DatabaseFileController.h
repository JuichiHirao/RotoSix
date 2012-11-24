//
//  DatabaseFileController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/22.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseFileController : NSObject

@property (nonatomic, copy, readwrite) NSString *dbmstPath;
@property (nonatomic, copy, readwrite) NSString *dbtrPath;

+ (NSString *)getMasterFile;
+ (void)clearMasterFile;
+ (NSString *)getTranFile;
+ (void)clearTranFile;

@end
