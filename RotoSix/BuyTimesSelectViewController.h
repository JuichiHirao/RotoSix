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
    NSInteger selPickerRow;
    NSInteger selPickerComponent;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnEnd;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnPastSetting;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectBuyTimesInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelPickerDateInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imageBuyTimesInfo;
@property (weak, nonatomic) IBOutlet UIView *viewSuperViewCover;

@property (strong, nonatomic) NSArray *arrLottery;
@property (weak, nonatomic) id <BuyTimesSelectDelegate> delegate;

- (IBAction)barBtnEndPress:(id)sender;
- (IBAction)barBtnCancelPress:(id)sender;
- (IBAction)barBtnPastSettingPress:(id)sender;

@end

@protocol BuyTimesSelectDelegate <NSObject>

- (void)BuyTimesSelectBtnEnd:(BuyTimesSelectViewController *)controller SelectIndex:(NSInteger)index SelectLottery:(Lottery *)lottery SelectTimes:(NSInteger)buyTimes;
- (void)BuyTimesSelectBtnCancel:(BuyTimesSelectViewController *)controller;

@end