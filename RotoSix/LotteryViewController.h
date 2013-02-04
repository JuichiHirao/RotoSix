//
//  LotteryViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/28.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"

@class LotteryDataController;

@interface LotteryViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *lotteryView;
@property (nonatomic, strong) LotteryDataController *dataController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tabitemRefresh;

- (IBAction)tabitemRefreshPress:(id)sender;

@end
