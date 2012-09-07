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

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */
/*
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
} */
- (void)viewWillAppear:(BOOL)animated {
    // Update the view with current data before it is displayed.
    [super viewWillAppear:animated];

/*
    histDetailView.backgroundColor = [UIColor clearColor];
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 3.0, 15.0, 15.0)];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    imgBg.image = theImage;
    
    histDetailView.backgroundView = imgBg;
 */
    NSString *str = buyHist.set01;
    NSLog(@"str [%@]", str);

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
            rows = 5;
            break;
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellBuyHistDetailLotteryNo";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *cellText = nil;
    NSLog(@" cell [%@] [%p]", CellIdentifier, cell);
    NSLog(@"indexPath row [%d] section [%d]", indexPath.row, indexPath.section);
    
    switch (indexPath.section) {
        case 0:
//            CellIdentifier = @"CellBuyHistDetailLotteryNo";
            cellText = @"TEST0";
            break;
        case 1:
//            CellIdentifier = @"CellBuyHistDetailPrizeMoney";
            cellText = @"TEST";
            break;
        case 2:
//            CellIdentifier = @"CellBuyHistDetailSetNo";
            cellText = @"TEST2";
            break;
        default:
            cellText = @"DEFAULT";
            break;
    }
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = cellText;
    
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
