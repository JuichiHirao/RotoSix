//
//  BuyRegistViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberSelectViewController.h"
#import "BuyTimesSelectViewController.h"
#import "BuyHistory.h"

@class NumberSelectViewController;
@class BuyTimesSelectViewController;

@protocol BuyRegistDelegate;

@interface BuyRegistViewController : UITableViewController <NumberSelectDelegate, BuyTimesSelectDelegate>
{
    NSArray *listData;
    id <BuyRegistDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UITableView *buyRegistView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tabitemSave;

@property (weak, nonatomic) id <BuyRegistDelegate> delegate;

@property (strong, nonatomic) NSArray *arrLottery;

@property (nonatomic) NSInteger selIndex;
@property (nonatomic, strong) Lottery *selLottery;
@property (nonatomic) NSInteger selBuyTimes;
@property (nonatomic, strong) BuyHistory *buyHist;
@property (nonatomic, strong) NSString *selBuyNumbers;
@property (nonatomic) NSInteger selBuyNo;

- (IBAction)tabitemSavePress:(id)sender;

@end

@protocol BuyRegistDelegate <NSObject>

- (void)RegistBuyHistoryEnd;

@end
