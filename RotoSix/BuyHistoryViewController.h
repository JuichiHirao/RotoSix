//
//  BuyHistoryViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/08/27.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyRegistViewController.h"
#import "QuartzTextNumDelegate.h"
#import "TableDisplaySetting.h"

@class BuyHistDataController;
@class BuyRegistViewController;

@interface BuyHistoryViewController : UseModalTableViewController <BuyRegistDelegate, TableDisplaySettingEnd> {
    BOOL isCellSetting;
    NSMutableArray *marrQuartzTextDelegate;
    TableDisplaySetting *dispSetting;
    CGFloat scrollPosiHeight;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tabitemDisplaySetting;

@property (nonatomic, strong) BuyHistDataController *dataController;

@property (strong, nonatomic) IBOutlet UITableView *histTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *buyHistCell;

- (IBAction)tabitemDisplaySettingPress:(id)sender;

@end
