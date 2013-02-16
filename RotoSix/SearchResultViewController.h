//
//  SearchResultViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/11.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryDataController.h"
#import "Search.h"

@protocol SearchResultDelegate;

@interface SearchResultViewController : UITableViewController {
    NSArray *arrResult;
    id <SearchResultDelegate> delegate;
}

@property (weak, nonatomic) id <SearchResultDelegate> delegate;
@property (nonatomic, strong) Search *search;

@end

@protocol SearchResultDelegate <NSObject>

- (void)RegistSearchEnd;

@end
