//
//  BuyHistDetailViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberSelectViewController.h"
#import "Lottery.h"
#import "UseModalTableViewController.h"

@class BuyHistory;
@class NumberSelectViewController;

@interface BuyHistDetailViewController : UseModalTableViewController <NumberSelectDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *histDetailView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tabitemSave;

@property (nonatomic, strong) BuyHistory *buyHist;
@property (nonatomic, strong) Lottery *lottery;
@property (nonatomic, strong) NSString *selBuyNumbers;
@property (nonatomic) NSInteger selBuyNo;

- (IBAction)tabitemSavePress:(id)sender;
- (void)btnEditPressed;

@end
