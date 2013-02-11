//
//  SearchResultViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/11.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryDataController.h"

@interface SearchResultViewController : UITableViewController {
    NSMutableArray *arrResult;
}

@property (nonatomic, strong) NSString *selNumSet;

@end
