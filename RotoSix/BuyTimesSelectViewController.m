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
    
    //arrLottery = [BuyHistDataController makeDefaultTimesData];
    
    // 次回の当選日を初期の選択状態にする
    [picker selectRow:10 inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnEndPressed:(id)sender {
    NSInteger com01 = [picker selectedRowInComponent:0];
    NSInteger com02 = [picker selectedRowInComponent:1];
    
    NSLog(@"%d  %d", com01, com02);
    Lottery *selLottery = [arrLottery objectAtIndex:com01];
    
    [[self delegate] BuyTimesSelectBtnEnd:self SelectIndex:com01 SelectLottery:selLottery SelectTimes:com02+1];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnCancelPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setPicker:nil];
    [super viewDidUnload];
}

#pragma mark - Pcker Delegate Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return 15;
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

    //Return the UILabel to the PickerView.
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"TEST\nだよ";
}

@end
