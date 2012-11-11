//
//  BuyTimesSelectViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/07.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyTimesSelectViewController.h"

@interface BuyTimesSelectViewController ()

@end

@implementation BuyTimesSelectViewController

@synthesize picker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 2;
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    NSLog(@"viewForRow component [%d]  row [%d]", component, row);
    
    //Update the frame size of the label.
    CGRect frame = CGRectMake(0,0,150,40);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    
    //Set the properties of the label as per requirement.
    [pickerLabel setTextAlignment:UITextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [pickerLabel setNumberOfLines:2];
    
    if (component==1) {
        [pickerLabel setText:@"dynamic text from\n an array or dictionary"];
    }
    else {
        [pickerLabel setText:@"第704回"];
    }

    //Return the UILabel to the PickerView.
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"TEST\nだよ";
}

- (void) test {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    // 年月日をとりだす
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                        fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSLog(@"year: %d month: %d, day: %d", year, month, day);
    //=> year: 2010 month: 5, day: 22
    
    // 週や曜日などをとりだす
    comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                        fromDate:date];
    NSInteger week = [comps week]; // 今年に入って何週目か
    NSInteger weekday = [comps weekday]; // 曜日
    NSInteger weekdayOrdinal = [comps weekdayOrdinal]; // 今月の第何曜日か
    NSLog(@"week: %d weekday: %d weekday ordinal: %d", week, weekday, weekdayOrdinal);
    //=> week: 21 weekday: 7(日曜日) weekday ordinal: 4(第4日曜日)
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    //lbLotteryDate.text = [outputDateFormatter stringFromDate:buyHistAtIndex.lotteryDate];

    
    // sqlite3から最新の回数を取得する
    
    // 回数を元に当日の回数を割り出す

    // 当日から未来の抽選日・回数（５つ）、過去の抽選日・回数（１０個）を取得する
}

@end
