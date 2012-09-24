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

@interface BuyHistoryViewController ()

@end

@implementation BuyHistoryViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    BuyHistDataController *data = [[BuyHistDataController alloc] init];
    dataController = data;
    NSLog(@"viewDidLoad [%d]", [dataController countOfList]);

    histTableView.backgroundColor = [UIColor clearColor];
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 3.0, 15.0, 15.0)];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    imgBg.image = theImage;

    histTableView.backgroundView = imgBg;
    
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
//	imageView.image = [UIImage imageNamed:@"Background.png"];
    
    isCellSetting = NO;
    
    //[self createTableCell];
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
    
    NSLog(@"cellForRowAtIndexPath [%d]", indexPath.row);
    BuyHistory *buyHistAtIndex = [dataController objectInListAtIndex:indexPath.row];
    
    //if (indexPath.row == 0) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    if (isCellSetting==YES) {
        NSLog(@"%@", [NSString stringWithFormat:@"cellForRowAtIndexPath isCellSetting YES"]);
    }
    else {
        NSLog(@"%@", [NSString stringWithFormat:@"cellForRowAtIndexPath isCellSetting NO"]);
    }
    
    cntArrayBuyNo = 0;
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
    
    arrmBuyNo = [NSMutableArray array];
    
    CGFloat x = 121.0;
    CGFloat y = 3.0;
    CGFloat width = 20.0;
    CGFloat height = 20.0;
    
    for (int idx=0; idx < 5; idx++ ) {
        x = 121.0;
        for (int idxSub=0; idxSub < 6; idxSub++) {
            [arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
            x = x + 26;
            cntArrayBuyNo++;
        }
        y = y + 22;
    }
    
    for (int idx=0; idx < cntArrayBuyNo; idx++) {
        [cell.contentView addSubview:[arrmBuyNo objectAtIndex:idx]];
    }
    
    cell.backgroundView = [[UIImageView alloc] init];
        
    NSString *imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
    rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
//    rowBackground = [UIImage imageNamed:@"CellBackground.png"];
    
    ((UIImageView *)cell.backgroundView).image = rowBackground;

    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    lbLotteryDate.text = [outputDateFormatter stringFromDate:buyHistAtIndex.lotteryDate];
    
    lbKaisuu.text = [NSString stringWithFormat:@"第%d回", buyHistAtIndex.lotteryNo];      // @"第689回";

//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"BallIcon-48" ofType:@"png"];
    // データの取得
    BuyHistory *buyHist = [dataController objectInListAtIndex:indexPath.row];
    
    int idxArrmBuyNo = 0;
    for (int idxBuySet=0; idxBuySet<5; idxBuySet++) {
        NSString *setNo = [buyHist getSetNo:idxBuySet];
        
        if ([setNo length] <= 0) {
            continue;
        }
        
        NSArray *arrBuySingleNo = [setNo componentsSeparatedByString:@","];
        
        for (int idx=0; idx < [arrBuySingleNo count]; idx++) {
            NSString *strNo = [arrBuySingleNo objectAtIndex:idx];
            NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            UIImageView *img = [arrmBuyNo objectAtIndex:idxArrmBuyNo];
            
            img.image = theImage;
            idxArrmBuyNo++;
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
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
}

#pragma mark Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"BuyHistDetail"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        BuyHistDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.buyHist= [dataController objectInListAtIndex:selectedRowIndex.row];
    }
}

@end
