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

@interface BuyRegistViewController : UITableViewController <NumberSelectDelegate>
{
    NSArray *listData;
}

@property (strong, nonatomic) IBOutlet UITableView *buyRegistView;

@property (strong, nonatomic) NSArray *listData;
@property (nonatomic, strong) BuyHistory *buyHist;
@property (nonatomic, strong) NSString *selBuyNumbers;
@property (nonatomic) NSInteger selBuyNo;

@end
