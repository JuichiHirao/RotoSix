//
//  BuyHistoryViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/08/27.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistoryViewController.h"
#import "BuyHistDetailViewController.h"
#import "BuyHistDataController.h"
#import "BuyHistory.h"
#import "BuyRegistViewController.h"

@interface BuyHistoryViewController ()

@property (nonatomic, strong) BuyRegistViewController *buyRegistViewController;

@end

@implementation BuyHistoryViewController

@synthesize buyRegistViewController=_buyRegistViewController;

@synthesize dataController;
@synthesize histTableView;
@synthesize buyHistCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)RegistBuyHistoryEnd:(BuyRegistViewController *)controller {
    NSLog(@"RegistBuyHistoryEnd");
    [dataController reloadAll];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [histTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated {

    // super viewWillAppearをcallするとindexPathForSelectedRowがクリアされるので、その前に取得
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    NSLog(@"viewWillAppear animated[%d] row [%d]", animated, selectedRowIndex.row);
    
    [super viewWillAppear:animated];
    
    if ([dataController countOfList] > 0) {
        // 更新した行だけをリロード、セル再表示する
        if ([dataController isDbUpdate:selectedRowIndex.row]) {
            [dataController reload:selectedRowIndex.row];
            
            NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:selectedRowIndex.row inSection:0];
            NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [histTableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [dataController setDbUpdate:selectedRowIndex.row];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    BuyHistDataController *data = [[BuyHistDataController alloc] init];
    dataController = data;
    NSLog(@"viewDidLoad [%d]", [dataController countOfList]);
    //[data createDemoFromDb];

    histTableView.backgroundColor = [UIColor clearColor];
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 3.0, 15.0, 15.0)];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    imgBg.image = theImage;

    histTableView.backgroundView = imgBg;
    
    isCellSetting = NO;
    
    //[super setEditing:NO animated:YES];

}

- (void)viewDidUnload
{
    [self setHistTableView:nil];
    [self setBuyHistCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [dataController removeObjectInListAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return [dataController countOfList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    NSLog(@"numberOfRowsInSection [%d]", [dataController countOfList]);
    return [dataController countOfList];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuyHistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *lbKaisuu, *lbLotteryDate;
    UIImage *rowBackground;
    
    BuyHistory *buyHistAtIndex = [dataController objectInListAtIndex:indexPath.row];
    NSLog(@"cellForRowAtIndexPath sec[%d] row[%d]  buyHist.lotteryTimes [%d]", indexPath.section, indexPath.row, buyHistAtIndex.lotteryTimes);

    //if (indexPath.row == 0) {
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:1];

    NSInteger idxImgTag;
    if (lbl==nil) {
        NSLog(@"cell create");
        
        lbLotteryDate = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, 120.0, 15.0)];
        lbLotteryDate.tag = 1;
        lbLotteryDate.backgroundColor = [UIColor clearColor];
        lbLotteryDate.font = [UIFont systemFontOfSize:12.0];
        lbLotteryDate.textAlignment = UITextAlignmentLeft;
        lbLotteryDate.textColor = [UIColor blackColor];
        
        [cell.contentView addSubview:lbLotteryDate];
        
        lbKaisuu = [[UILabel alloc] initWithFrame:CGRectMake(3.0, 15.0, 50.0, 15.0)];
        lbKaisuu.tag = 2;
        lbKaisuu.backgroundColor = [UIColor clearColor];
        lbKaisuu.font = [UIFont systemFontOfSize:10.0];
        lbKaisuu.textAlignment = UITextAlignmentCenter;
        lbKaisuu.textColor = [UIColor blackColor];

        [cell.contentView addSubview:lbKaisuu];
        
        CGFloat x = 121.0;
        CGFloat y = 3.0;
        CGFloat width = 20.0;
        CGFloat height = 20.0;
        
        idxImgTag = 11;
        for (int idx=0; idx < 5; idx++ ) {
            x = 121.0;
            for (int idxSub=0; idxSub < 6; idxSub++) {
//                [arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                img.tag = idxImgTag;
                x = x + 26;
                
                [cell.contentView addSubview:img];
                idxImgTag++;
            }
            y = y + 22;
        }
        
        cell.backgroundView = [[UIImageView alloc] init];
    }
    else {
        lbLotteryDate = (UILabel*)[cell.contentView viewWithTag:1];
        lbKaisuu = (UILabel*)[cell.contentView viewWithTag:2];
        
        UIImageView *img;
        for (idxImgTag = 11; idxImgTag <= 40; idxImgTag++) {
            img = (UIImageView*)[cell.contentView viewWithTag:idxImgTag];

            if (img==nil) {
                break;
            }
            img.image = nil;
        }
    }
    
    NSString *imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
    rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
//    rowBackground = [UIImage imageNamed:@"CellBackground.png"];
    
    ((UIImageView *)cell.backgroundView).image = rowBackground;

    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    lbLotteryDate.text = [outputDateFormatter stringFromDate:buyHistAtIndex.lotteryDate];
    
    lbKaisuu.text = [NSString stringWithFormat:@"第%d回", buyHistAtIndex.lotteryTimes];      // @"第689回";
    NSLog(@"cellForRowAtIndexPath sec[%d] row[%d]  buyHist.lotteryTimes [%d]   lbLotteryDate.text [%@]"
          , indexPath.section, indexPath.row, buyHistAtIndex.lotteryTimes, [outputDateFormatter stringFromDate:buyHistAtIndex.lotteryDate]);

//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"BallIcon-48" ofType:@"png"];
    // データの取得
    //BuyHistory *buyHist = [dataController objectInListAtIndex:indexPath.row];
    
    idxImgTag = 11;
    for (int idxBuySet=0; idxBuySet<5; idxBuySet++) {
        NSString *setNo = [buyHistAtIndex getSetNo:idxBuySet];
        
        if ([setNo length] <= 0) {
            continue;
        }
        
        NSArray *arrBuySingleNo = [setNo componentsSeparatedByString:@","];
        
        for (int idx=0; idx < [arrBuySingleNo count]; idx++) {
            NSString *strNo = [arrBuySingleNo objectAtIndex:idx];
            NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idxImgTag];

            img.image = theImage;
            idxImgTag++;
        }
    }

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    //[self performSegueWithIdentifier:@"BuyHistDetail" sender:self];
    //BuyHistDetailViewController *detailViewController = [[BuyHistDetailViewController alloc] initWithStyle:<#(UITableViewStyle)#>]
    //[self performSegueWithIdentifier:@"BuyHistDetail" sender:self];
}

#pragma mark Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"BuyHistDetail"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        BuyHistDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.buyHist= [dataController objectInListAtIndex:selectedRowIndex.row];
    }
    else if ([[segue identifier] isEqualToString:@"BuyRegist"]) {
        BuyRegistViewController *buyRegistViewController = [segue destinationViewController];
        buyRegistViewController.delegate = self;
    }
}

// アクセサリタイプがタップされた場合も行の選択と同じ動作をする（詳細画面へ遷移）
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"BuyHistDetail" sender:self];
}

@end
