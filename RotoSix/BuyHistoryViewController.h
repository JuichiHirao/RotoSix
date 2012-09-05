//
//  BuyHistoryViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/08/27.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuyHistDataController;

@interface BuyHistoryViewController : UITableViewController

@property (nonatomic, strong) BuyHistDataController *dataController;

@property (strong, nonatomic) IBOutlet UITableView *histTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *buyHistCell;

@end
