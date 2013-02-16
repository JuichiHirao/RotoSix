//
//  SearchResultViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/11.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

@synthesize delegate = _delegate;
@synthesize search;

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

    NSMutableArray *arrWorkResult = [LotteryDataController getSearchNumSetAll:search.num_set];
    //arrResult = [LotteryDataController getSearchNumSetAll:search.num_set];
    NSSortDescriptor *sortDescripter = [[NSSortDescriptor alloc] initWithKey:@"times" ascending:NO];
    
    NSMutableArray *arrSort = [NSArray arrayWithObjects:sortDescripter, nil];
    arrResult = [arrWorkResult sortedArrayUsingDescriptors:arrSort];
    //arrResult = [LotteryDataController getSearchNumSetAll:search.num_set];
    
    search.registDate = [NSDate new];
    if (arrResult != nil) {
        search.matchCount = [arrResult count];
    }
    else
        search.matchCount = 0;

    [search save];

    [[self delegate] RegistSearchEnd];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrResult != nil && [arrResult count] > 0) {
        return [arrResult count];
    }
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrResult != nil && [arrResult count] > 0) {
        return 112;
    }
    
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *lbKaisuu, *lbLotteryDate, *lbLotteryRanking;
    UIImage *rowBackground;
    
    if (arrResult == nil || [arrResult count] <= 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0, 300.0, 60.0)];
        lbLotteryDate.tag = 1;
        
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16.0];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = @"一致データなし";
        
        [cell.contentView addSubview:label];
        
        return cell;
    }
    Lottery *lotteryAtIndex = arrResult[indexPath.row];
    NSLog(@"cellForRowAtIndexPath sec[%d] row[%d]  buyHist.lotteryTimes [%d]", indexPath.section, indexPath.row, lotteryAtIndex.times);
    
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

        lbLotteryRanking = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 5.0, 50.0, 20.0)];
        lbLotteryRanking.tag = 2;
        lbLotteryRanking.backgroundColor = [UIColor clearColor];
        lbLotteryRanking.font = [UIFont systemFontOfSize:18.0];
        lbLotteryRanking.textAlignment = UITextAlignmentCenter;
        lbLotteryRanking.textColor = [UIColor blackColor];
        
        [cell.contentView addSubview:lbLotteryRanking];

        CGFloat x = 10.0;
        CGFloat y = 40.0;
        CGFloat width = 35.0;
        CGFloat height = 35.0;
        
        idxImgTag = 11;
        for (int idxSub=0; idxSub < 7; idxSub++) {
            //                [arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            img.tag = idxImgTag;
            x = x + 45;
            
            [cell.contentView addSubview:img];
            idxImgTag++;
        }
        
        cell.backgroundView = [[UIImageView alloc] init];
    }
    else {
        lbLotteryDate = (UILabel*)[cell.contentView viewWithTag:1];
        lbKaisuu = (UILabel*)[cell.contentView viewWithTag:2];
        
        UIImageView *img;
        for (idxImgTag = 11; idxImgTag <= 17; idxImgTag++) {
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
    lbLotteryDate.text = [outputDateFormatter stringFromDate:lotteryAtIndex.lotteryDate];
    
    lbKaisuu.text = [NSString stringWithFormat:@"第%d回", lotteryAtIndex.times];      // @"第689回";
    lbLotteryRanking.text = [NSString stringWithFormat:@"%d等", lotteryAtIndex.lotteryRanking];
    NSLog(@"cellForRowAtIndexPath sec[%d] row[%d]  buyHist.lotteryTimes [%d]   lbLotteryDate.text [%@]"
          , indexPath.section, indexPath.row, lotteryAtIndex.times, [outputDateFormatter stringFromDate:lotteryAtIndex.lotteryDate]);
    
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"BallIcon-48" ofType:@"png"];
    // データの取得
    //BuyHistory *buyHist = [dataController objectInListAtIndex:indexPath.row];
    
    idxImgTag = 11;
    NSString *setNo = [lotteryAtIndex num_set];
    
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
}

@end
