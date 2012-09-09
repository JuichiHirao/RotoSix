//
//  BuyHistDetailViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistDetailViewController.h"
#import "BuyHistory.h"

@interface BuyHistDetailViewController ()

@end

@implementation BuyHistDetailViewController

@synthesize histDetailView;
@synthesize buyHist;

- (void)viewWillAppear:(BOOL)animated {
    // Update the view with current data before it is displayed.
    [super viewWillAppear:animated];

//    histDetailView.backgroundColor = [UIColor clearColor];
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 3.0, 15.0, 15.0)];
    
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
    
    self.title = [NSString stringWithFormat:@"%@ (第%d回)", [outputDateFormatter stringFromDate:buyHist.lotteryDate], buyHist.lotteryNo];
    // Scroll the table view to the top before it appears
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
//    self.title = play.title;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
        case 0:
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 6;
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
            
            height = 60.0;
            break;
        case 1:
            height = 150.0;
            break;
        case 2:
            if (indexPath.row == 0) {
                height = 30.0;
            }
            else {
                height = 22.0;
            }
            break;
        default:
            break;
    }
    return height;
}
/*
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"当選番号";
            break;
        case 1:
            title = @"当選金額";
            break;
        case 2:
            title = @"購入番号";
            break;
        default:
            break;
    }
    return title;
}
 */
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
    UIImage *rowBackground;
    UIImageView *imgNo1, *imgNo2, *imgNo3, *imgNo4, *imgNo5, *imgNo6, *imgNo7;
    UIImageView *imgBuyNo1, *imgBuyNo2, *imgBuyNo3, *imgBuyNo4, *imgBuyNo5, *imgBuyNo6;
    
    NSString *cellText = nil;
    NSLog(@" cell [%@] [%p]", CellIdentifier, cell);
    NSLog(@"indexPath row [%d] section [%d]", indexPath.row, indexPath.section);
    //NSLog(@"cellForRowAtIndexPath before %f,%f",cell.contentView.frame.origin.x,cell.contentView.frame.size.width);
    
    UILabel *lbLotteryDate;

    switch (indexPath.section) {
        case 0:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            lbLotteryDate = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 3.0, 120.0, 15.0)];
            lbLotteryDate.tag = 1;
            lbLotteryDate.backgroundColor = [UIColor clearColor];
            lbLotteryDate.font = [UIFont systemFontOfSize:16.0];
            lbLotteryDate.textAlignment = UITextAlignmentLeft;
            lbLotteryDate.textColor = [UIColor blackColor];
            lbLotteryDate.text = @"当選番号";
            
            [cell.contentView addSubview:lbLotteryDate];

            imgNo1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 24.0, 35.0, 35.0)];
            imgNo2 = [[UIImageView alloc] initWithFrame:CGRectMake(44.0, 24.0, 35.0, 35.0)];
            imgNo3 = [[UIImageView alloc] initWithFrame:CGRectMake(83.0, 24.0, 35.0, 35.0)];
            imgNo4 = [[UIImageView alloc] initWithFrame:CGRectMake(122.0, 24.0, 35.0, 35.0)];
            imgNo5 = [[UIImageView alloc] initWithFrame:CGRectMake(161.0, 24.0, 35.0, 35.0)];
            imgNo6 = [[UIImageView alloc] initWithFrame:CGRectMake(200.0, 24.0, 35.0, 35.0)];
            imgNo7 = [[UIImageView alloc] initWithFrame:CGRectMake(239.0, 24.0, 35.0, 35.0)];
            [cell.contentView addSubview:imgNo1];
            [cell.contentView addSubview:imgNo2];
            [cell.contentView addSubview:imgNo3];
            [cell.contentView addSubview:imgNo4];
            [cell.contentView addSubview:imgNo5];
            [cell.contentView addSubview:imgNo6];
            [cell.contentView addSubview:imgNo7];

            //cell.backgroundView = [[UIImageView alloc] init];

            break;
        case 1:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            lbLotteryDate = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 3.0, 120.0, 15.0)];
            lbLotteryDate.tag = 1;
            lbLotteryDate.backgroundColor = [UIColor clearColor];
            lbLotteryDate.font = [UIFont systemFontOfSize:16.0];
            lbLotteryDate.textAlignment = UITextAlignmentLeft;
            lbLotteryDate.textColor = [UIColor blackColor];
            lbLotteryDate.text = @"当選金額";
            
            [cell.contentView addSubview:lbLotteryDate];
//            [cell.contentView addSubview:lbLottery01Label];
            [cell.contentView addSubview:[self createLabel:24.0 LabelText:@"1等"]];
            [cell.contentView addSubview:[self createLabel:42.0 LabelText:@"2等"]];
            [cell.contentView addSubview:[self createLabel:60.0 LabelText:@"3等"]];
            [cell.contentView addSubview:[self createLabel:78.0 LabelText:@"4等"]];
            [cell.contentView addSubview:[self createLabel:96.0 LabelText:@"5等"]];
            [cell.contentView addSubview:[self createLabel:114.0 LabelText:@"販売実績"]];
            [cell.contentView addSubview:[self createLabel:132.0 LabelText:@"キャリーオーバー"]];
            
            //cell.backgroundView = [[UIImageView alloc] init];
            break;
        case 2:
            if (indexPath.row == 0) {
                lbLotteryDate = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 3.0, 120.0, 15.0)];
                lbLotteryDate.tag = 1;
                lbLotteryDate.backgroundColor = [UIColor clearColor];
                lbLotteryDate.font = [UIFont systemFontOfSize:16.0];
                lbLotteryDate.textAlignment = UITextAlignmentLeft;
                lbLotteryDate.textColor = [UIColor blackColor];
                lbLotteryDate.text = @"購入番号";
                
                [cell.contentView addSubview:lbLotteryDate];
            }
            else {
                imgBuyNo1 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 0.5, 20.0, 20.0)];
                [cell.contentView addSubview:imgBuyNo1];
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

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"No03-35" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];

    NSString *imagePathBuy = [[NSBundle mainBundle] pathForResource:@"No01-20" ofType:@"png"];
    UIImage *theImageBuy = [UIImage imageWithContentsOfFile:imagePathBuy];

    imgNo1.image = theImage;
    imgNo2.image = theImage;
    imgNo3.image = theImage;
    imgNo4.image = theImage;
    imgNo5.image = theImage;
    imgNo6.image = theImage;
    imgNo7.image = theImage;

    imgBuyNo1.image = theImageBuy;

    NSLog(@"cell.contentView.bounds.size %f,%f",cell.contentView.bounds.size.width,cell.contentView.bounds.size.height);
    NSLog(@"cell.contentView.frame.size %f,%f",cell.contentView.frame.size.width, cell.contentView.frame.origin.x);
    
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
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@" cell [%p]", cell);
    NSLog(@"indexPath row [%d] section [%d]", indexPath.row, indexPath.section);
}

- (void)viewDidUnload {
    [self setHistDetailView:nil];
    [super viewDidUnload];
}
@end
