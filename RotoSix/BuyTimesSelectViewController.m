//
//  BuyTimesSelectViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/07.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyTimesSelectViewController.h"
#import "LotteryDataController.h"
#import "Lottery.h"
#import "BuyHistDataController.h"

@interface BuyTimesSelectViewController ()

@end

@implementation BuyTimesSelectViewController

@synthesize delegate = _delegate;
@synthesize picker;
@synthesize arrLottery;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 次回の当選日を初期の選択状態にする
    [picker selectRow:10 inComponent:0 animated:NO];
    
    _labelSelectBuyTimesInfo.lineBreakMode = UILineBreakModeWordWrap;
    _labelSelectBuyTimesInfo.numberOfLines = 2;
    
    [self displayPickerSelectDateInfo];
    
    [self displayLabelSelectBuyTimeInfo:10 inComponent:0];
}

- (void)viewDidUnload {
    [self setPicker:nil];
    [self setBarBtnCancel:nil];
    [self setBarBtnEnd:nil];
    [self setBarBtnPastSetting:nil];
    [self setLabelSelectBuyTimesInfo:nil];
    [self setLabelPickerDateInfo:nil];
    [self setImageBuyTimesInfo:nil];
    [self setViewSuperViewCover:nil];
    [super viewDidUnload];
}

// Pickerに設定可能な日付期間をLabelに表示する
- (void)displayPickerSelectDateInfo {
    Lottery *fromLottery = arrLottery[0];
    Lottery *toLottery = arrLottery[arrLottery.count - 1];

    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    
    NSString *dispInfo = [NSString stringWithFormat:@"%d回 %@ 〜 %d回 %@"
                         , fromLottery.times
                         , [outputDateFormatter stringFromDate:fromLottery.lotteryDate]
                         , toLottery.times
                         , [outputDateFormatter stringFromDate:toLottery.lotteryDate]];
    
    _labelPickerDateInfo.text = dispInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Bar Item Button Press Method
- (IBAction)barBtnEndPress:(id)sender {
    NSInteger com01 = [picker selectedRowInComponent:0];
    NSInteger com02 = [picker selectedRowInComponent:1];
    
    NSLog(@"%d  %d", com01, com02);
    Lottery *selLottery = [arrLottery objectAtIndex:com01];
    
    [[self delegate] BuyTimesSelectBtnEnd:self SelectIndex:com01 SelectLottery:selLottery SelectTimes:com02+1];
}

- (IBAction)barBtnCancelPress:(id)sender {
    [[self delegate] BuyTimesSelectBtnCancel:self];
}

- (IBAction)barBtnPastSettingPress:(id)sender {
    NSInteger selBuyDate = [picker selectedRowInComponent:0];
    
    Lottery *selLottery = arrLottery[selBuyDate];
    NSLog(@"row[%d]  %d回 ", selBuyDate, selLottery.times);
    
    arrLottery = [BuyHistDataController makePastTimesData:arrLottery];
    [self.picker reloadAllComponents];
    
    for (int idx=0; idx < arrLottery.count; idx++) {
        Lottery *lottery = arrLottery[idx];
        NSLog(@"%d回 ", lottery.times);
        
        if (lottery.times == selLottery.times) {
            [picker selectRow:idx inComponent:0 animated:NO];
            break;
        }
    }
    
    // Pickerに設定可能な日付期間をLabelに表示する
    [self displayPickerSelectDateInfo];
}

#pragma mark - Picker Delegate Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return [arrLottery count]-10;
    }
    
    return 10;
}

- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    [picker selectRow:9 inComponent:0 animated:NO];
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    //NSLog(@"viewForRow component [%d]  row [%d]", component, row);
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    
    Lottery *lottery;
    
    if (component==0) {
        lottery = [arrLottery objectAtIndex:row];
    }
    
    //Update the frame size of the label.
    CGRect frame = CGRectMake(0,0,150,40);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    
    //Set the properties of the label as per requirement.
    [pickerLabel setTextAlignment:UITextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [pickerLabel setNumberOfLines:2];
    
    if (component==1) {
        [pickerLabel setText:[NSString stringWithFormat:@"%d回", row+1]];
    }
    else {
        [pickerLabel setText:[NSString stringWithFormat:@"第%d回\n%@", lottery.times, [outputDateFormatter stringFromDate:lottery.lotteryDate]]];
    }

    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == selPickerRow && component == selPickerComponent) {
        return;
    }
    
    [self displayLabelSelectBuyTimeInfo:row inComponent:component];
    
    CGRect sourceImageFrame = _imageBuyTimesInfo.frame;
    CGRect sourceLabelFrame = _labelSelectBuyTimesInfo.frame;

    [UIView animateWithDuration:0.5f animations:^{
        _imageBuyTimesInfo.frame = CGRectMake(sourceImageFrame.origin.x, sourceImageFrame.origin.y, sourceImageFrame.size.width, 0);
        _labelSelectBuyTimesInfo.frame = CGRectMake(sourceLabelFrame.origin.x, sourceLabelFrame.origin.y, sourceLabelFrame.size.width, 0);
    }];

    [UIView animateWithDuration:0.5f animations:^{
        _imageBuyTimesInfo.frame = sourceImageFrame;
        _labelSelectBuyTimesInfo.frame = sourceLabelFrame;
    }];
}

-(void) displayLabelSelectBuyTimeInfo:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger selBuyDate = [picker selectedRowInComponent:0];
    NSInteger selTimes = [picker selectedRowInComponent:1];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"M/dd";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    
    int idxTimes = 0;
    NSString *buyDateInfo = @"";
    for (int idx=selBuyDate; idxTimes<=selTimes; idx++) {
        Lottery *lottery = arrLottery[idx];
        buyDateInfo = [NSString stringWithFormat:@"%@ %@", buyDateInfo, [outputDateFormatter stringFromDate:lottery.lotteryDate]];
        
        NSLog(@"didSelectRow buyDateInfo[%@]", [outputDateFormatter stringFromDate:lottery.lotteryDate]);
        idxTimes++;
    }
    
    _labelSelectBuyTimesInfo.text = buyDateInfo;
    selPickerRow = row;
    selPickerComponent = component;
}

@end
