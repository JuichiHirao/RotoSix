//
//  LotteryConnectionHandler.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/05.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import "LotteryConnectionHandler.h"

@implementation LotteryConnectionHandler

- (id)init {
	self = [super init];
	if (self) {
		receivedData = [[NSMutableData alloc] init];
	}
	return self;
}

// サーバからレスポンスヘッダを受け取ったときに呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// 送信されるデータの文字コードを取得
	NSString *encodingName = [response textEncodingName];
	
	NSLog(@"受信文字コード: %@", encodingName);
	
	if ([encodingName isEqualToString: @"euc-jp"]) {
		receivedDataEncoding = NSJapaneseEUCStringEncoding;
	} else {
		receivedDataEncoding = NSUTF8StringEncoding;
	}
}

// サーバからデータを受け取るたびに呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// 取得したデータをreceivedDataへ格納する
	NSLog(@"受信データ（バイト数）: %d", [data length]);
	[receivedData appendData:data];
}

// データの取得が終了したときに呼び出される
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *result = [[NSString alloc] initWithData:receivedData encoding:receivedDataEncoding];
	NSLog(@"データの受信完了: %@", result);
	//[result release];
	//[receivedData release];
}

@end
