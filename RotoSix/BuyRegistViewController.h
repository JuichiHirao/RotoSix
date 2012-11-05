//
//  BuyRegistViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberSelectViewController.h"

@class NumberSelectViewController;

@interface BuyRegistViewController : UITableViewController
{
    NSArray *listData;
}

@property (strong, nonatomic) NSArray *listData;

@end
