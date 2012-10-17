//
//  BuyHistDetailViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuyHistory;
@class NumberSelectViewController;

@interface BuyHistDetailViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *histDetailView;

@property (nonatomic, strong) BuyHistory *buyHist;
@property (nonatomic, strong) NSString *selBuyNumbers;

- (void)btnEditPressed;

@end
