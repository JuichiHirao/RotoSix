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

@class NumberSelectViewController;
@class SearchResultViewController;

@interface SearchViewController : UITableViewController <NumberSelectDelegate> {
    NSString *selNameSet;
}


- (void)btnSelectSearchNumberPress:(id)sender;

@end
