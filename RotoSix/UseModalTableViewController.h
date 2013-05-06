//
//  UseModalViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/05/06.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyTimesSelectViewController.h"
#import "NumberSelectViewController.h"

@interface UseModalTableViewController : UITableViewController <NumberSelectDelegate, BuyTimesSelectDelegate>
{
    BuyTimesSelectViewController *buyTimesSelectViewController;
    NumberSelectViewController *numberSelectViewController;
}

- (void) showModal:(UIView *) modalView;
- (void) hideModal:(UIView *) modalView;

- (void) showModalBuyTimesSelect:(NSArray *)arrLottery;
- (void) showModalNumberInput:(NSString *)selNumbers;
- (void) showModalNumberInput:(NSString *)selNumbers MinSelectNumber:(NSInteger)minSelNum MaxSelectNumber:(NSInteger)maxSelNum;

@end
