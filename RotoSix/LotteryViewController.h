//
//  LotteryViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/28.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "Lottery.h"

@class LotteryDataController;
@class SBJsonStreamParser;
@class SBJsonStreamParserAdapter;

@interface LotteryViewController : UITableViewController {
    SBJsonStreamParser *parser;
    SBJsonStreamParserAdapter *adapter;
    
    NSMutableData *receivedData;
	NSStringEncoding receivedDataEncoding;
}

@property (strong, nonatomic) IBOutlet UITableView *lotteryView;
@property (nonatomic, strong) LotteryDataController *dataController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tabitemRefresh;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)tabitemRefreshPress:(id)sender;

@end
