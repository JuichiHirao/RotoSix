//
//  BuyTimesSelectViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/07.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"

@protocol BuyTimesSelectDelegate;

@interface BuyTimesSelectViewController : UIViewController
    <UIPickerViewDataSource, UIPickerViewDelegate> {
        
    UIPickerView *picker;
}

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *arrLottery;
@property (weak, nonatomic) id <BuyTimesSelectDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnPastSetting;

- (IBAction)btnEndPressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnPastSettingPressed:(id)sender;

@end

@protocol BuyTimesSelectDelegate <NSObject>

- (void)BuyTimesSelectBtnEnd:(BuyTimesSelectViewController *)controller SelectIndex:(NSInteger)index SelectLottery:(Lottery *)lottery SelectTimes:(NSInteger)buyTimes;

@end