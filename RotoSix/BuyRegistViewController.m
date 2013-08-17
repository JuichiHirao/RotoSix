//
//  BuyRegistViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyRegistViewController.h"
#import "BuyHistDataController.h"
#import "LotteryDataController.h"
#import "BuyTimesSelectViewController.h"
#import "AppDelegate.h"
#import "UseModalTableViewController.h"

@interface BuyRegistViewController ()

@property (nonatomic, strong) NumberSelectViewController *numberSelViewController;
@property (nonatomic, strong) BuyTimesSelectViewController *buyTimesSelectViewController;

@end

@implementation BuyRegistViewController

@synthesize delegate = _delegate;

@synthesize numberSelViewController=_numberSelViewController;
@synthesize buyTimesSelectViewController=_buyTimesSelectViewController;
@synthesize buyHist;
@synthesize buyRegistView;
@synthesize arrLottery;
@synthesize selIndex;
@synthesize selLottery;
@synthesize selBuyTimes;
@synthesize selBuyNumbers;
@synthesize selBuyNo;

#pragma mark - from SelectView Delegate
-(void)NumberSelectBtnEnd:(NumberSelectViewController *)controller SelectNumber:(NSString *)name {
    
    if (buyHist == nil ) {
        buyHist = [[BuyHistory alloc] init];
    }
    
    if (![name isEqual:@"Cancel"]) {
        NSString *beforeNo = [buyHist getSetNo:selBuyNo];
        
        [buyHist changeSetNo:selBuyNo SetNo:name];
        
        if (![beforeNo isEqualToString:name]) {
            NSLog(@"NumberSelectBtnEnd change!! beforeNo [%@] -> [%@]  row [%d]  buyHist getCount[%d]", beforeNo, name, selBuyNo, [buyHist getCount]);
        }
        else {
            NSLog(@"NumberSelectBtnEnd no change!! beforeNo [%@] -> [%@]  row [%d]  buyHist getCount[%d]", beforeNo, name, selBuyNo, [buyHist getCount]);
        }
        
        // セクションを全て更新（各種のデリゲートメソッドも再実行される heightForRowAtIndexPath,numberOfRowsInSection etc...）
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [buyRegistView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [buyRegistView endUpdates];
    }
    
    [self hideModal:controller.view];
}

- (void)BuyTimesSelectBtnEnd:(BuyTimesSelectViewController *)controller SelectIndex:(NSInteger)index SelectLottery:(Lottery *)lottery SelectTimes:(NSInteger)buyTimes {
    
    selIndex = index;
    selLottery = lottery;
    selBuyTimes = buyTimes;
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];

    NSLog(@"BuyTimesSelectBtnEnd IDX[%d] 抽選日 [%@] 回数 [%d]   購入回数 [%d]", selIndex, [outputDateFormatter stringFromDate:selLottery.lotteryDate], selLottery.times, selBuyTimes);
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [buyRegistView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self hideModal:controller.view];
}

- (void)BuyTimesSelectBtnCancel:(BuyTimesSelectViewController *)controller {
    [self hideModal:controller.view];
}

#pragma mark - View Controller Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrLottery = [BuyHistDataController makeDefaultTimesData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBuyRegistView:nil];
    [self setTabitemSave:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        int count = [buyHist getCount];
        
        if (indexPath.row+1 > count)
            return;
        
        [buyHist removeSetData:indexPath.row];
        // 最大まで追加されている場合にdeleteRowsAtIndexPathsを実行すると
        // 「さらに追加」があるので行数は変わらないのに、行を削除しようとするのでExceptionになるので
        // 最大の場合はセクションの更新により、行の削除を行う
        if (count==5) {
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [buyRegistView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"購入回数";
            break;
        case 1:
            title = @"購入番号";
            break;
        default:
            break;
    }
    return title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (1 == indexPath.section);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"BuyRegist heightForRowAtIndexPath [%d]", 1);
    if (indexPath.section == 0) {
        if (selBuyTimes > 0) {
            return 80;
        }
        else {
            return 60;
        }
    }
    if (indexPath.section == 1) {
        if (buyHist.getCount > 0) {
            return 30;
        }
        else {
            return 60.0;
        }
    }
    
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"BuyRegist numberOfRowsInSection [%d] buyHist.getCount [%d]", section, buyHist.getCount);
    if (section == 1) {
        if (buyHist.getCount > 0) {
            if (buyHist.getCount >= 5) {
                return buyHist.getCount;
            }
            return buyHist.getCount + 1;
        }
        else {
            return 1;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    UITableViewCell *cell;
    
    NSInteger buySetNo = -1;
    
    CGFloat x = 10.0;
    CGFloat y = 2.0;
    CGFloat width = 23.0;
    CGFloat height = 23.0;
    
    switch (indexPath.section) {
        case 0:
            NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
            CellIdentifier = @"CellNewRegistSection00";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (selBuyTimes > 0) {
                cell = nil;
            }
            
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
                if (selBuyTimes <= 0) {
                    UILabel *lbl;

                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:11.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor grayColor];
                    lbl.text = @"ここをタップして";
                    [cell.contentView addSubview:lbl];
                    
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:11.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor grayColor];
                    lbl.text = @"回数を選択して下さい";
                    [cell.contentView addSubview:lbl];
                }
                else {
                    UILabel *lbl;
                    
                    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
                    NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
                    [outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
                    [outputDateFormatter setDateFormat:outputDateFormatterStr];
                    
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 20)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:17.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor blackColor];
                    lbl.text = [NSString stringWithFormat:@"第%d回  %@", selLottery.times, [outputDateFormatter stringFromDate:selLottery.lotteryDate]];
                    [cell.contentView addSubview:lbl];
                    
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:17.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor blackColor];
                    lbl.text = [NSString stringWithFormat:@"継続回数  %d回", selBuyTimes];
                    [cell.contentView addSubview:lbl];
                }
            }
            
            break;
        case 1:
            NSLog(@"CellNewRegistSection01 [%@] [%p] secion01 [%d]  buyHist.getCount [%d]", CellIdentifier, cell, indexPath.row, buyHist.getCount);
            CellIdentifier = @"CellNewRegistSection01";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            buySetNo = indexPath.row;

            if (buyHist.getCount>0) {
                cell = nil;
            }

            if (cell==nil) {
                NSLog(@"cell nil CellIdentifier [%@] [%p] secion01 [%d]", CellIdentifier, cell, indexPath.row);
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
                if (buyHist.getCount<=0) {
                    UILabel *lbl;
                    
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:11.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor grayColor];
                    lbl.text = @"ここをタップして";
                    [cell.contentView addSubview:lbl];

                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:11.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor grayColor];
                    lbl.text = @"購入した番号を入力して下さい";
                    [cell.contentView addSubview:lbl];
                }
                else {
                    if (buyHist.getCount>indexPath.row) {
                        x = 10.0;
                        y = 2.0;
                        width = 23.0;
                        height = 23.0;
                        
                        int idx=0;
                        for (idx=0; idx < 6; idx++) {
                            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                            //[arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                            img.tag = idx+1;
                            x = x + 26;
                            [cell.contentView addSubview:img];
                            //[cell.contentView addSubview:[arrmBuyNo objectAtIndex:idx]];
                        }
                        
                        // ステータスの表示用
                        x = x + 26;
                        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                        //[arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                        //[cell.contentView addSubview:[arrmBuyNo objectAtIndex:6]];
                        img.tag = idx+1;
                        [cell.contentView addSubview:img];
                    }
                    else {
                        UILabel *lbl;
                        
                        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
                        lbl.backgroundColor = [UIColor clearColor];
                        lbl.font = [UIFont systemFontOfSize:12.0];
                        lbl.textAlignment = UITextAlignmentCenter;
                        lbl.textColor = [UIColor blackColor];
                        lbl.text = @"さらに追加";
                        [cell.contentView addSubview:lbl];
                    }
                }
            }
            
            break;
        default:
            //cellText = @"DEFAULT";
            break;
    }

    if (indexPath.section == 1) {
        NSLog(@"cell section01 image load secion01 [%d]", indexPath.row);
        NSString *setNo = [buyHist getSetNo:buySetNo];
        
        NSArray *arrBuySingleNo = [setNo componentsSeparatedByString:@","];
        
        for (int idx=0; idx < [arrBuySingleNo count]; idx++) {
            NSString *strNo = [arrBuySingleNo objectAtIndex:idx];
            NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            
            UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idx+1];
            img.image = theImage;
            //NSLog(@"cell Sec01 idx[%d]", idx);
        }
    }
    
    return cell;
}

#pragma mark - Item Action Method
- (IBAction)btnCancelPress:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        //NSLog(@" cell [%p]", cell);
        //NSLog(@"indexPath row [%d] section [%d]", indexPath.row, indexPath.section);
        
        [self showModalBuyTimesSelect:arrLottery];
    }
    
    if (indexPath.section==1) {
        selBuyNumbers = [buyHist getSetNo:indexPath.row];
        selBuyNo = indexPath.row;
        
        [self showModalNumberInput:selBuyNumbers];
    }
}

- (IBAction)tabitemSavePress:(id)sender {
    // チェックを行う
    NSString *strMessage;
    if (selLottery.lotteryDate == nil || selLottery.times <= 0 || selBuyTimes <= 0) {
        strMessage = @"購入回数、継続回数を選択して下さい";
    }
    else if ([buyHist getCount] <= 0) {
        strMessage = @"購入した番号を１組以上入力して下さい";
    }
    
    if (strMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未選択エラー" message:strMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
        [alert show];
        
        return;
    }
    
    NSLog(@"tabitemSavePress selIndex [%d]  selBuyTimes [%d]  arrLottery.count [%d]", selIndex, selBuyTimes, arrLottery.count);

    // 購入回数がarrLotteryに無い場合は過去データの保存処理を行う
    bool isPastSave = YES;
    for (int idx=0; idx<[arrLottery count]; idx++) {
        Lottery *data = arrLottery[idx];
        if (selLottery.times == data.times) {
            isPastSave = NO;
            break;
        }
    }
    
    if (isPastSave == YES) {
        for (int idx=0; idx < selBuyTimes; idx++) {
            
            BuyHistory *data = [[BuyHistory alloc] init];
            
            data.set01 = buyHist.set01;
            data.set02 = buyHist.set02;
            data.set03 = buyHist.set03;
            data.set04 = buyHist.set04;
            data.set05 = buyHist.set05;
            
            Lottery *lotteryData = [LotteryDataController getTimes:selLottery.times+idx];
            data.lotteryDate = lotteryData.lotteryDate;
            data.lotteryTimes = lotteryData.times;
            
            [data save];
        }
    }
    else {
        for (int idx=selIndex; idx < selIndex+selBuyTimes; idx++) {
            
            BuyHistory *data = [[BuyHistory alloc] init];
            
            data.set01 = buyHist.set01;
            data.set02 = buyHist.set02;
            data.set03 = buyHist.set03;
            data.set04 = buyHist.set04;
            data.set05 = buyHist.set05;
            
            Lottery *lotteryData = [arrLottery objectAtIndex:idx];
            data.lotteryDate = lotteryData.lotteryDate;
            data.lotteryTimes = lotteryData.times;
            
            [data save];
        }
    }
    
    // 購入情報画面もdelegateを実行
    [[self delegate] RegistBuyHistoryEnd];
    
    // Saveボタンは無効にする
    [_tabitemSave setEnabled:FALSE];
}

@end
