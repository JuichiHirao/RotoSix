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
#import "BuyHistDataController.h"
#import "LotteryDataController.h"

@interface BuyHistDetailViewController ()

@property (nonatomic, strong) NumberSelectViewController *numberSelViewController;

@end

@implementation BuyHistDetailViewController

@synthesize numberSelViewController=_numberSelViewController;
@synthesize histDetailView;
@synthesize buyHist;
@synthesize lottery;
@synthesize selBuyNumbers;
@synthesize selBuyNo;

// DELEGATE 
-(void)NumberSelectBtnEnd:(NumberSelectViewController *)controller SelectNumber:(NSString *)name {
    NSString *beforeNo = [buyHist getSetNo:selBuyNo];

    if (buyHist.lotteryTimes > 0) {
        [buyHist changeSetNo:selBuyNo SetNo:name];
        
        if (![beforeNo isEqualToString:name]) {
            [buyHist setUpdate:selBuyNo Status:1];
            NSLog(@"NumberSelectBtnEnd change!! beforeNo [%@] -> [%@]  row [%d]", beforeNo, name, selBuyNo);
        }
    }
    else {
        // 当選情報からの遷移だとBuyHistが無いので、生成
        buyHist = [[BuyHistory alloc] init];
        buyHist.lotteryTimes = lottery.times;
        buyHist.lotteryDate = lottery.lotteryDate;
        [buyHist changeSetNo:0 SetNo:name];
    }
    
    // セクションを全て更新（各種のデリゲートメソッドも再実行される heightForRowAtIndexPath,numberOfRowsInSection etc...）
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [histDetailView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - View Controller Method

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[data createDemoFromDb];

    // 購入画面からの遷移の場合
    if (lottery.times <= 0) {
        NSLog(@"viewDidLoad buyHist.lotteryTimes [%d]", buyHist.lotteryTimes);
        // 当選情報をsqliteから取得する
        lottery = [LotteryDataController getTimes:buyHist.lotteryTimes];
        
        // sqliteに当選情報が存在する場合
        if (lottery != nil
            && lottery.times > 0) {
            [buyHist lotteryCheck:lottery];
            [buyHist save];
        }
    }
    else {
        NSLog(@"viewDidLoad lottery.times [%d]", lottery.times);
        NSMutableArray* arr = [BuyHistDataController getTimes:lottery.times];
        if (arr.count > 0) {
            buyHist = arr[0];
        }
    }
    
    // http://stackoverflow.com/questions/9367898/long-press-gesture-on-table-view-cell
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [self.histDetailView addGestureRecognizer:lpgr];
    
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTap:)];
    tapgr.delegate = self;
    [self.histDetailView addGestureRecognizer:tapgr];
    
    // 下にヘルプの文字列を出す
    // 行の長押しをすると、番号のコピーが行えます
}

- (void)viewDidUnload {
    NSLog(@"BuyHistDetailVC viewDidUnload");
    [self setHistDetailView:nil];
    [super viewDidUnload];
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
    
    NSString *str = buyHist.set01;
    NSLog(@"str [%@]", str);
    
    // 詳細画面のタイトルを設定、表示（抽選日と回数を表示）
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    
    if (buyHist.lotteryTimes > 0) {
        self.title = [NSString stringWithFormat:@"%@ (第%d回)", [outputDateFormatter stringFromDate:buyHist.lotteryDate], buyHist.lotteryTimes];
    }
    else {
        self.title = [NSString stringWithFormat:@"%@ (第%d回)", [outputDateFormatter stringFromDate:lottery.lotteryDate], lottery.times];
    }
    // Scroll the table view to the top before it appears
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
    //    self.title = play.title;
}

#pragma mark - GestureRecognizer Delegate Method

// 選択行が長押しされた場合
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.histDetailView];

    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized)
    {
        //Do something to tell the user!
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSIndexPath *indexPath = [self.histDetailView indexPathForRowAtPoint:p];
        if (indexPath == nil)
            NSLog(@"long press on table view but not on a row");
        else
            NSLog(@"long press on table view at section %d row %d", indexPath.section, indexPath.row);
    }
}

// 画面から受け取ったタッチイベントを受け取るか、無視するかを判定するメソッド
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    // http://stackoverflow.com/questions/8192480/uitapgesturerecognizer-breaks-uitableview-didselectrowatindexpath
    // を参考にして実装したが、戻りが必ずYESか NOにしかならない、背景のviewの場合のみYESをリターンしたいがうまくいかない
    // そのため、編集モードの場合は、解除する処理を本メソッドの中に実装（すっきりはしないが我慢！！）
    //if (self.histDetailView.superview != nil) {
    //    if ([touch.view isDescendantOfView:self.histDetailView]) {
    //        NSLog(@"shouldReceiveTouch touch.view isDescendantOfView:self.histDetailView %d", touch.view.tag);
    //        // we touched our control surface
    //        return NO; // ignore the touch
    //    }
    //}
    //return YES; // handle the touch

    NSLog(@"shouldReceiveTouch touch.view isDescendantOfView:self.histDetailView %d", touch.view.tag);
    
    // TAG 102 ボタンが編集の場合
    if (touch.view.tag == 102) {
        if (self.editing) {
            [self setEditing:NO animated:YES];
            return NO; // ignore the touch
        }
        else {
            [self setEditing:YES animated:YES];
        }
        return NO;
    }
    
    if (self.editing) {
        [self setEditing:NO animated:YES];
    }
    return NO; // ignore the touch
}

#pragma mark - Action Method

- (void)backgroundTap:(id)sender {
    // shouldReceiveTouchの中で処理は行っているので、UITapGestureRecognizerで指定しているので、一応用意しておく空メソッド
    NSLog(@"backgroundTap");
}

- (void)btnEditPressed
{
    NSLog(@"btnEdtiPressed");
    // shouldReceiveTouchで処理を行っているので、本メソッドでは何もしない
}

- (void)btnSavePressed
{
    [buyHist save];

    [histDetailView beginUpdates];
    for (int idx=0; idx < 5; idx++) {
        
        if ([buyHist isUpdate:idx]) {
            [buyHist setUpdate:idx Status:0];
            
            NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:idx inSection:1];
            NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [histDetailView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"reloadRowsAtIndexPaths [%d]", idx);
        }
    }
    buyHist.isDbUpdate = 1;
    [histDetailView endUpdates];
    //sleep(5);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // sqliteに当選情報が存在する場合
    if (lottery != nil
        && lottery.times > 0) {
        return 3;
    }
    return 2;
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
            if (lottery == nil)
                rows = 1;
            else
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

- (CAGradientLayer *) greyGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    
    UIColor *color1 = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    
    [gradient setColors:[NSArray arrayWithObjects:(id)color1.CGColor, (id)color2.CGColor, nil]];
    return gradient;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // http://www.gersh.no/posts/view/default_styling_of_sections_headers_in_uitableview_grouped
    CGFloat width = CGRectGetWidth(tableView.bounds);
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,height)];

	view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	CGRect labelFrame = CGRectMake(20, 2, width, 30);
	//if(section == 0) {
	//	labelFrame.origin.y = 13;
	//}
	UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.shadowColor = [UIColor colorWithWhite:1.0 alpha:1];
	label.shadowOffset = CGSizeMake(0, 1);
	label.textColor = [UIColor colorWithRed:0.265 green:0.294 blue:0.367 alpha:1.000];
	label.text = [self tableView:tableView titleForHeaderInSection:section];
	[view addSubview:label];

    if (section == 1) {
        // 保存ボタン
        UIButton *btn;
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(190,2,50,25);
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnSavePressed) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 101;
        [view addSubview:btn];
        
        // 編集ボタン
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(250,2,50,25);
        [btn setTitle:@"編集" forState:UIControlStateNormal];
        //[btn addTarget:self action:@selector(btnEditPressed) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 102;
        [view addSubview:btn];
    }

	return view;
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

- (void) createLabelLotteryMessage:(UIView *)view LabelText:(NSString *)labelText {
    UILabel *lbl;
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 260, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.textColor = [UIColor blackColor];
    lbl.text = labelText;
    [view addSubview:lbl];
    
    return;
}

- (void) createLabelLotteryNumber:(UIView *)view LabelText:(NSString *)labelText Unit:(NSInteger)unit Amount:(NSInteger) amount {
    UILabel *lbl;
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 60, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.textAlignment = UITextAlignmentRight;
    lbl.textColor = [UIColor blackColor];
    lbl.text = labelText;
    [view addSubview:lbl];

    lbl = [[UILabel alloc] initWithFrame:CGRectMake(80, 4, 70, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.textAlignment = UITextAlignmentRight;
    lbl.textColor = [UIColor blackColor];
    NSNumberFormatter *fmtNum = [[NSNumberFormatter alloc]init];
    [fmtNum setPositiveFormat:@"###,###,###,##0"];
    NSString *dispText = [NSString stringWithFormat:@"%@口", [fmtNum stringFromNumber:[NSNumber numberWithInt:unit]]];
    lbl.text = dispText;
    [view addSubview:lbl];

    lbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 4, 120, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.textAlignment = UITextAlignmentRight;
    lbl.textColor = [UIColor blackColor];
    dispText = [NSString stringWithFormat:@"%@ 円", [fmtNum stringFromNumber:[NSNumber numberWithInt:amount]]];
    lbl.text = dispText;
    [view addSubview:lbl];

    return;
}

- (void) createLabelLotteryInfo:(UIView *)view LabelText:(NSString *)labelText Amount:(NSInteger) amount {
    UILabel *lbl;
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 4, 90, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.textAlignment = UITextAlignmentRight;
    lbl.textColor = [UIColor blackColor];
    lbl.text = labelText;
    [view addSubview:lbl];

    NSNumberFormatter *fmtNum = [[NSNumberFormatter alloc]init];
    [fmtNum setPositiveFormat:@"###,###,###,##0"];

    lbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 4, 120, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.textAlignment = UITextAlignmentRight;
    lbl.textColor = [UIColor blackColor];
    NSString *dispText = [NSString stringWithFormat:@"%@ 円", [fmtNum stringFromNumber:[NSNumber numberWithInt:amount]]];
    lbl.text = dispText;
    [view addSubview:lbl];
    
    return;
}

- (void) createLabelLotteryInfo:(UIView *)view LabelText:(NSString *)labelText LongAmount:(long long int) amount {
    UILabel *lbl;
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 4, 90, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.textAlignment = UITextAlignmentRight;
    lbl.textColor = [UIColor blackColor];
    lbl.text = labelText;
    [view addSubview:lbl];
    
    NSNumberFormatter *fmtNum = [[NSNumberFormatter alloc]init];
    [fmtNum setPositiveFormat:@"###,###,###,###,##0"];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 4, 120, 15)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.textAlignment = UITextAlignmentRight;
    lbl.textColor = [UIColor blackColor];
    //NSString *dispText = [NSString stringWithFormat:@"%@円", [fmtNum stringFromNumber:[NSNumber numberWithLongLong:lottery.sales]]];
    NSString *dispText = [NSString stringWithFormat:@"%@ 円", [fmtNum stringFromNumber:[NSNumber numberWithLongLong:amount]]];
    lbl.text = dispText;
    [view addSubview:lbl];
    
    return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    UITableViewCell *cell;
    
    NSString *cellText = nil;
    NSLog(@"indexPath row [%d] section [%d]", indexPath.row, indexPath.section);
    //NSLog(@"cellForRowAtIndexPath before %f,%f",cell.contentView.frame.origin.x,cell.contentView.frame.size.width);
    
    int buySetNo = -1;

    CGFloat x = 10.0;
    CGFloat y = 2.0;
    CGFloat width = 23.0;
    CGFloat height = 23.0;

    switch (indexPath.section) {
        case 0:
            //NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
            CellIdentifier = @"CellBuyHistDetailSection00";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                // sqliteに当選情報が存在する場合
                if (lottery != nil
                    && lottery.times > 0) {
                    x = 10.0;
                    y = 2.0;
                    width = 35.0;
                    height = 35.0;
                    
                    for (int idx=0; idx < 7; idx++) {
                        //[arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                        img.tag = idx+1;
                        x = x + 39.0;
                        //[cell.contentView addSubview:[arrmBuyNo objectAtIndex:idx]];
                        [cell.contentView addSubview:img];
                    }
                }
                else {
                    UILabel *lbl;
                    
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 300, 30)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:18.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor blackColor];
                    lbl.text = @"未　当　選";
                    [cell.contentView addSubview:lbl];
                }
                
                //cell.backgroundView = [[UIImageView alloc] init];
            }

            break;
        case 1:
            CellIdentifier = @"CellBuyHistDetailSection01";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            buySetNo = indexPath.row;

            if (cell==nil) {
                //NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
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
            
            break;
        case 2:
            CellIdentifier = @"CellBuyHistDetailSection02";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                //NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
                if (lottery == nil) {
                    [self createLabelLotteryMessage:cell.contentView LabelText:@"当選番号 未発表"];
                }
                else {
                    if (indexPath.row == 0) {
                        [self createLabelLotteryNumber:cell.contentView LabelText:@"1等" Unit:lottery.one_unit Amount:lottery.one_amount];
                    }
                    else if (indexPath.row == 1) {
                        [self createLabelLotteryNumber:cell.contentView LabelText:@"2等" Unit:lottery.two_unit Amount:lottery.two_amount];
                    }
                    else if (indexPath.row == 2) {
                        [self createLabelLotteryNumber:cell.contentView LabelText:@"3等" Unit:lottery.three_unit Amount:lottery.three_amount];
                    }
                    else if (indexPath.row == 3) {
                        [self createLabelLotteryNumber:cell.contentView LabelText:@"4等" Unit:lottery.four_unit Amount:lottery.four_amount];
                    }
                    else if (indexPath.row == 4) {
                        [self createLabelLotteryNumber:cell.contentView LabelText:@"5等" Unit:lottery.five_unit Amount:lottery.five_amount];
                    }
                    else if (indexPath.row == 5) {
                        [self createLabelLotteryInfo:cell.contentView LabelText:@"販売実績" LongAmount:lottery.sales];
                    }
                    else if (indexPath.row == 6) {
                        [self createLabelLotteryInfo:cell.contentView LabelText:@"キャリーオーバー" Amount:lottery.carryover];
                    }
                }
            }
            break;
        default:
            cellText = @"DEFAULT";
            break;
    }
    //NSString *imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
    //rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
    //((UIImageView *)cell.backgroundView).image = rowBackground;

    if (indexPath.section==0) {
        if (lottery != nil
            && lottery.times > 0) {
            NSArray *arrLotteryNo = [lottery.num_set componentsSeparatedByString:@","];
            
            for (int idx=0; idx < 7; idx++) {
                NSString *strNo = [arrLotteryNo objectAtIndex:idx];
                NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
                NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
                UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
                
                UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idx+1];
                img.image = theImage;
            }
        }
        else {
            
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

            UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idx+1];
            img.image = theImage;
            //NSLog(@"cell Sec01 idx[%d]", idx);
        }
        
        if ([buyHist isUpdate:buySetNo]) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"StatusUpdate35" ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            //UIImageView *img = [arrmBuyNo objectAtIndex:6];
            //img.image = theImage;
            
            UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:7];
            img.image = theImage;
        }
    }
    
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

@end
