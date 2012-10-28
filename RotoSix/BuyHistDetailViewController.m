//
//  BuyHistDetailViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistDetailViewController.h"
#import "BuyHistory.h"
#import "NumberSelectViewController.h"

@interface BuyHistDetailViewController ()

@property (nonatomic, strong) NumberSelectViewController *numberSelViewController;

@end

@implementation BuyHistDetailViewController

@synthesize numberSelViewController=_numberSelViewController;
@synthesize histDetailView;
@synthesize buyHist;
@synthesize selBuyNumbers;
@synthesize selBuyNo;

// DELEGATE 
-(void)NumberSelectBtnEnd:(NumberSelectViewController *)controller SelectNumber:(NSString *)name {
    NSString *beforeNo = [buyHist getSetNo:selBuyNo];

    [buyHist changeSetNo:selBuyNo SetNo:name];
    
    if (![beforeNo isEqualToString:name]) {
        [buyHist setUpdate:selBuyNo Status:1];
        NSLog(@"NumberSelectBtnEnd change!! beforeNo [%@] -> [%@]  row [%d]", beforeNo, name, selBuyNo);
    }
    
    NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:selBuyNo inSection:1];
    NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [histDetailView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated {
    // Update the view with current data before it is displayed.
    [super viewWillAppear:animated];

//    histDetailView.backgroundColor = [UIColor clearColor];
    
    NSInteger a = self.navigationController.navigationBar.frame.size.height;
    NSLog(@"navigationBar.frame.size.height [%d]", a);
/*
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"DetailImage" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    imgBg.image = theImage;
    
    histDetailView.backgroundView = imgBg;
 */

    // 保存ボタン
	UIButton *btn;
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(190,85,50,25);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnSavePressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];

    // 編集ボタン
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(250,85,50,25);
    [btn setTitle:@"編集" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnEditPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];

    NSString *str = buyHist.set01;
    NSLog(@"str [%@]", str);

    // 詳細画面のタイトルを設定、表示（抽選日と回数を表示）
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    
    self.title = [NSString stringWithFormat:@"%@ (第%d回)", [outputDateFormatter stringFromDate:buyHist.lotteryDate], buyHist.lotteryNo];
    // Scroll the table view to the top before it appears
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
//    self.title = play.title;
}

- (void)btnEditPressed
{
    if (self.editing) {
        [self setEditing:NO animated:YES];
    }
    else {
        [self setEditing:YES animated:YES];
    }
}

- (void)btnSavePressed
{
    [buyHist save];

    for (int idx=0; idx < 5; idx++) {
        
        if ([buyHist isUpdate:idx]) {
            [buyHist setUpdate:idx Status:0];
            
            NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:idx inSection:1];
            NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [histDetailView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (1 == indexPath.section);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    NSLog(@"編集モード突入");

    [super setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@" indexPath.section [%d] indexPath.row [%d] buyHist.getCount [%d]", indexPath.section, indexPath.row, [buyHist getCount] );
    // 編集モードで最後の行のみ追加モードにする、但し購入が最大の５行以内の場合
    if (tableView.editing) {
        if ([buyHist getCount] >= 5) {
            return UITableViewCellEditingStyleDelete;
        }
        else {
            if ([buyHist getCount] == indexPath.row) {
                return UITableViewCellEditingStyleInsert;
            }
            else {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"Insert");
        
        if (_numberSelViewController == nil) {
            _numberSelViewController = [[NumberSelectViewController alloc] init];
        }
        selBuyNumbers = @"";
        
        [self performSegueWithIdentifier:@"NumberInput" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"NumberInput"]) {
        
        //NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        NumberSelectViewController *numInputlViewController = [segue destinationViewController];
        numInputlViewController.buyNumbers = selBuyNumbers;
        numInputlViewController.delegate = self;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    NSInteger cnt = 0;
    
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            cnt = [buyHist getCount];
            if (cnt < 5) {
                rows = cnt + 1;
            }
            else {
                rows = 5;
            }
            break;
        case 2:
            rows = 7;
            break;
        default:
            break;
    }
    return rows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    switch (indexPath.section) {
        case 0:
            
            height = 40.0;
            break;
        case 1:
            height = 35.0;
            break;
        case 2:
            height = 25.0;
            break;
        default:
            break;
    }
    return height;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"当選番号";
            break;
        case 1:
            title = @"購入番号";
            break;
        case 2:
            title = @"当選金額";
            break;
        default:
            break;
    }
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UILabel *) createLabel:(CGFloat)y LabelText:(NSString *)labelText {
    UILabel *lbLottery01Label;
    
    lbLottery01Label = [[UILabel alloc] initWithFrame:CGRectMake(8.0, y, 90.0, 15.0)];
    lbLottery01Label.backgroundColor = [UIColor clearColor];
    lbLottery01Label.font = [UIFont systemFontOfSize:11.0];
    lbLottery01Label.textAlignment = UITextAlignmentRight;
    lbLottery01Label.textColor = [UIColor blackColor];
    lbLottery01Label.text = labelText;
    
    return lbLottery01Label;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellBuyHistDetailLotteryNo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *cellText = nil;
    NSLog(@" cell [%@] [%p]", CellIdentifier, cell);
    NSLog(@"indexPath row [%d] section [%d]", indexPath.row, indexPath.section);
    //NSLog(@"cellForRowAtIndexPath before %f,%f",cell.contentView.frame.origin.x,cell.contentView.frame.size.width);
    
    int buySetNo = 0;
    NSMutableArray* arrmBuyNo = [NSMutableArray array];

    CGFloat x = 10.0;
    CGFloat y = 2.0;
    CGFloat width = 23.0;
    CGFloat height = 23.0;

    switch (indexPath.section) {
        case 0:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

            x = 10.0;
            y = 2.0;
            width = 35.0;
            height = 35.0;
            
            for (int idx=0; idx < 7; idx++) {
                [arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                x = x + 39.0;
                [cell.contentView addSubview:[arrmBuyNo objectAtIndex:idx]];
            }
            
            //cell.backgroundView = [[UIImageView alloc] init];

            break;
        case 1:
            buySetNo = indexPath.row;
            
            x = 10.0;
            y = 2.0;
            width = 23.0;
            height = 23.0;
            
            for (int idx=0; idx < 6; idx++) {
                [arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                x = x + 26;
                [cell.contentView addSubview:[arrmBuyNo objectAtIndex:idx]];
            }

            // ステータスの表示用
            x = x + 26;
            [arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
            [cell.contentView addSubview:[arrmBuyNo objectAtIndex:6]];

            // 編集ボタン
//            btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake(170,2,50,25);
//            [btn setTitle:@"編集" forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(btnEditPressed) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:btn];

            //imgBuyNo1 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 1.5, 20.0, 20.0)];
            //[cell.contentView addSubview:imgBuyNo1];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            break;
        case 2:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            if (indexPath.row == 0) {
                [cell.contentView addSubview:[self createLabel:4.0 LabelText:@"1等"]];
            }
            else if (indexPath.row == 1) {
                [cell.contentView addSubview:[self createLabel:4.0 LabelText:@"2等"]];
            }
            else if (indexPath.row == 2) {
                [cell.contentView addSubview:[self createLabel:4.0 LabelText:@"3等"]];
            }
            else if (indexPath.row == 3) {
                [cell.contentView addSubview:[self createLabel:4.0 LabelText:@"4等"]];
            }
            else if (indexPath.row == 4) {
                [cell.contentView addSubview:[self createLabel:4.0 LabelText:@"5等"]];
            }
            else if (indexPath.row == 5) {
                [cell.contentView addSubview:[self createLabel:4.0 LabelText:@"販売実績"]];
            }
            else if (indexPath.row == 6) {
                [cell.contentView addSubview:[self createLabel:4.0 LabelText:@"キャリーオーバー"]];
            }
            
            //cell.backgroundView = [[UIImageView alloc] init];
            break;
        default:
            cellText = @"DEFAULT";
            break;
    }
    //NSString *imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
    //rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
    //((UIImageView *)cell.backgroundView).image = rowBackground;

    if (indexPath.section==0) {
        NSArray *arrLotteryNo = [@"1,2,8,16,25,40,27" componentsSeparatedByString:@","];
        
        for (int idx=0; idx < 7; idx++) {
            NSString *strNo = [arrLotteryNo objectAtIndex:idx];
            NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            UIImageView *img = [arrmBuyNo objectAtIndex:idx];
            
            img.image = theImage;
        }
    }
    else if (indexPath.section==1) {
        NSString *setNo = [buyHist getSetNo:buySetNo];
        
        NSArray *arrBuySingleNo = [setNo componentsSeparatedByString:@","];
        
        for (int idx=0; idx < [arrBuySingleNo count]; idx++) {
            NSString *strNo = [arrBuySingleNo objectAtIndex:idx];
            NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            UIImageView *img = [arrmBuyNo objectAtIndex:idx];
            
            img.image = theImage;
        }
        
        if ([buyHist isUpdate:buySetNo]) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"StatusUpdate35" ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            UIImageView *img = [arrmBuyNo objectAtIndex:6];
            
            img.image = theImage;
        }
    }

    //NSLog(@"cell.contentView.bounds.size %f,%f",cell.contentView.bounds.size.width,cell.contentView.bounds.size.height);
    //NSLog(@"cell.contentView.frame.size %f,%f",cell.contentView.frame.size.width, cell.contentView.frame.origin.x);
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1) {
        return;
    }
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@" cell [%p]", cell);
    NSLog(@"indexPath row [%d] section [%d]", indexPath.row, indexPath.section);
    
    if (_numberSelViewController == nil) {
        _numberSelViewController = [[NumberSelectViewController alloc] init];
    }
    
    if (indexPath.section==1) {
        selBuyNumbers = [buyHist getSetNo:indexPath.row];
        selBuyNo = indexPath.row;
    }
    
    [self performSegueWithIdentifier:@"NumberInput" sender:self];
/*  黒の背景を止めたいので、以下の記述したが正しく動作せず
    iOS View Controller プログラミングガイド120216.pdf P43 リスト2-4 View Controllerをウインドウのルートview Controllerとしてインストール
    UIWindow *win = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NumberSelectViewController *numInputlViewController = [[NumberSelectViewController alloc] init];
    numInputlViewController.buyNumbers = selBuyNumbers;
    win.rootViewController = numInputlViewController;
    
    [win makeKeyAndVisible];
 */
}

- (void)viewDidUnload {
    [self setHistDetailView:nil];
    [super viewDidUnload];
}
@end
