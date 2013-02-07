//
//  LotteryConnectionHandler.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/05.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface LotteryConnectionHandler : NSObject {
	NSMutableData *receivedData;
	NSStringEncoding receivedDataEncoding;
    
    SBJsonStreamParser *parser;
    SBJsonStreamParserAdapter *adapter;
}

@end
