//
//  SearchViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/11.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberSelectViewController.h"
#import "SearchResultViewController.h"
#import "UseModalTableViewController.h"

@class NumberSelectViewController;
@class SearchResultViewController;
@class SearchDataController;

@interface SearchViewController : UseModalTableViewController <NumberSelectDelegate, SearchResultDelegate> {
    Search *selSearch;
}

@property (nonatomic, strong) SearchDataController *dataController;

@end
