//
//  BuyRegistViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyRegistViewController : UIViewController
                <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *listData;
}

@property (strong, nonatomic) NSArray *listData;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UITableView *tableViewBuyNumber;

- (IBAction)btnCancelPress:(id)sender;

@end
