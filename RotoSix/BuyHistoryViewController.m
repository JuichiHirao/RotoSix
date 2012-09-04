//
//  BuyHistoryViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/08/27.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistoryViewController.h"
#import "BuyHistDetailViewController.h"

@interface BuyHistoryViewController ()

@end

@implementation BuyHistoryViewController
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    histTableView.backgroundColor = [UIColor clearColor];
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 3.0, 15.0, 15.0)];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    imgBg.image = theImage;

    histTableView.backgroundView = imgBg;
//	imageView.image = [UIImage imageNamed:@"Background.png"];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuyHistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //histTableCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *lbKaisuu, *lbLotteryDate;
    UIImage *rowBackground;
    UIImageView *imgBar;
    UIImageView *img1_1, *img1_2, *img1_3, *img1_4, *img1_5, *img1_6;
    UIImageView *img2_1, *img2_2, *img2_3, *img2_4, *img2_5, *img2_6;
    UIImageView *img3_1, *img3_2, *img3_3, *img3_4, *img3_5, *img3_6;
    UIImageView *img4_1, *img4_2, *img4_3, *img4_4, *img4_5, *img4_6;
    UIImageView *img5_1, *img5_2, *img5_3, *img5_4, *img5_5, *img5_6;
    
    UIBezierPath *aPath;
    
    //if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];        
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

        lbLotteryDate = [[UILabel alloc] initWithFrame:CGRectMake(3.0, 0.0, 120.0, 15.0)];
        lbLotteryDate.tag = 1;
        lbLotteryDate.backgroundColor = [UIColor clearColor];
        lbLotteryDate.font = [UIFont systemFontOfSize:12.0];
        lbLotteryDate.textAlignment = UITextAlignmentLeft;
        lbLotteryDate.textColor = [UIColor blackColor];
        
        [cell.contentView addSubview:lbLotteryDate];

        lbKaisuu = [[UILabel alloc] initWithFrame:CGRectMake(3.0, 18.0, 50.0, 15.0)];
        lbKaisuu.tag = 2;
        lbKaisuu.backgroundColor = [UIColor clearColor];
        lbKaisuu.font = [UIFont systemFontOfSize:10.0];
        lbKaisuu.textAlignment = UITextAlignmentCenter;
        lbKaisuu.textColor = [UIColor blackColor];

        [cell.contentView addSubview:lbKaisuu];

        imgBar = [[UIImageView alloc] initWithFrame:CGRectMake(118.0, 2.0, 123.0, 18.0)];
        img1_1 = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 3.0, 15.0, 15.0)];
        img1_2 = [[UIImageView alloc] initWithFrame:CGRectMake(140.0, 3.0, 15.0, 15.0)];
        img1_3 = [[UIImageView alloc] initWithFrame:CGRectMake(159.0, 3.0, 15.0, 15.0)];
        img1_4 = [[UIImageView alloc] initWithFrame:CGRectMake(178.0, 3.0, 15.0, 15.0)];
        img1_5 = [[UIImageView alloc] initWithFrame:CGRectMake(197.0, 3.0, 15.0, 15.0)];
        img1_6 = [[UIImageView alloc] initWithFrame:CGRectMake(216.0, 3.0, 15.0, 15.0)];
        img2_1 = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 24.0, 15.0, 15.0)];
        img2_2 = [[UIImageView alloc] initWithFrame:CGRectMake(143.0, 24.0, 15.0, 15.0)];
        img2_3 = [[UIImageView alloc] initWithFrame:CGRectMake(165.0, 24.0, 15.0, 15.0)];
        img3_1 = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 35.0, 15.0, 15.0)];
        img3_2 = [[UIImageView alloc] initWithFrame:CGRectMake(143.0, 35.0, 15.0, 15.0)];
        img3_3 = [[UIImageView alloc] initWithFrame:CGRectMake(165.0, 35.0, 15.0, 15.0)];
//        img.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;

        [cell.contentView addSubview:imgBar];
        [cell.contentView addSubview:img1_1];
        [cell.contentView addSubview:img1_2];
        [cell.contentView addSubview:img1_3];
        [cell.contentView addSubview:img1_4];
        [cell.contentView addSubview:img1_5];
        [cell.contentView addSubview:img1_6];
        [cell.contentView addSubview:img2_1];
        [cell.contentView addSubview:img2_2];
        [cell.contentView addSubview:img2_3];
        [cell.contentView addSubview:img3_1];
        [cell.contentView addSubview:img3_2];
        [cell.contentView addSubview:img3_3];
        
        cell.backgroundView = [[UIImageView alloc] init];
    //}

    NSString *imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
    rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
//    rowBackground = [UIImage imageNamed:@"CellBackground.png"];
    
    ((UIImageView *)cell.backgroundView).image = rowBackground;

    lbLotteryDate.text = @"平成24年12月20日";
    lbKaisuu.text = @"第689回";

    aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0, 0.0, 100.0, 18.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10.0, 10.0)];
    [aPath moveToPoint:CGPointMake(120.0, 2.0)];
    [[UIColor blackColor] setStroke];
    [aPath stroke];

    NSString *imageBarPath = [[NSBundle mainBundle] pathForResource:@"BackGroundBar" ofType:@"png"];
    UIImage *theImageBar = [UIImage imageWithContentsOfFile:imageBarPath];

//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"BallIcon-48" ofType:@"png"];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"No01-15" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];

    imgBar.image = theImageBar;
    img1_1.image = theImage;
    img1_2.image = theImage;
    img1_3.image = theImage;
    img1_4.image = theImage;
    img1_5.image = theImage;
    img1_6.image = theImage;
    img2_1.image = theImage;
    img2_2.image = theImage;
    img2_3.image = theImage;
    img3_1.image = theImage;
    img3_2.image = theImage;
    img3_3.image = theImage;
//    cell.textLabel.text = @"TEST1";
    
    // Configure the cell...
    
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
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"BuyHistDetail"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        BuyHistDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.buyHist= nil;
    }
}

@end
