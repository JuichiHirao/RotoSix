//
//  BuyHistoryViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/08/27.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistoryViewController.h"

@interface BuyHistoryViewController ()

@end

@implementation BuyHistoryViewController
@synthesize histTableView;

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
}

- (void)viewDidUnload
{
    [self setHistTableView:nil];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *lbKaisuu, *lbLotteryDate;
    UIImageView *img, *img15, *img20, *img25, *img30;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

        lbLotteryDate = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 15.0)];
        lbLotteryDate.tag = 1;
        lbLotteryDate.font = [UIFont systemFontOfSize:12.0];
        lbLotteryDate.textAlignment = UITextAlignmentCenter;
        lbLotteryDate.textColor = [UIColor blackColor];
        
        [cell.contentView addSubview:lbLotteryDate];

        lbKaisuu = [[UILabel alloc] initWithFrame:CGRectMake(121.0, 3.0, 50.0, 15.0)];
        lbKaisuu.tag = 2;
        lbKaisuu.font = [UIFont systemFontOfSize:10.0];
        lbKaisuu.textAlignment = UITextAlignmentCenter;
        lbKaisuu.textColor = [UIColor blackColor];

        [cell.contentView addSubview:lbKaisuu];

        img = [[UIImageView alloc] initWithFrame:CGRectMake(131.0, 3.0, 10.0, 10.0)];
        img15 = [[UIImageView alloc] initWithFrame:CGRectMake(146.0, 3.0, 15.0, 15.0)];
        img20 = [[UIImageView alloc] initWithFrame:CGRectMake(166.0, 3.0, 20.0, 20.0)];
        img25 = [[UIImageView alloc] initWithFrame:CGRectMake(196.0, 3.0, 25.0, 25.0)];
        img30 = [[UIImageView alloc] initWithFrame:CGRectMake(226.0, 3.0, 30.0, 30.0)];
//        img.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;

        [cell.contentView addSubview:img];
        [cell.contentView addSubview:img15];
        [cell.contentView addSubview:img20];
        [cell.contentView addSubview:img25];
        [cell.contentView addSubview:img30];
//        layerBg.contents = (id)[UIImage imageNamed:@"BallIcon-48.png"].CGImage;
        
    }
    
    lbLotteryDate.text = @"平成24年12月20日";
    lbKaisuu.text = @"第689回";
    
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"BallIcon-48" ofType:@"png"];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"No01" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
//    NSString *imagePath15 = [[NSBundle mainBundle] pathForResource:@"No01-15" ofType:@"png"];
    NSString *imagePath15 = [[NSBundle mainBundle] pathForResource:@"NewNo01" ofType:@"png"];
    UIImage *theImage15 = [UIImage imageWithContentsOfFile:imagePath15];

    NSString *imagePath20 = [[NSBundle mainBundle] pathForResource:@"No01-20" ofType:@"png"];
    UIImage *theImage20 = [UIImage imageWithContentsOfFile:imagePath20];

    NSString *imagePath25 = [[NSBundle mainBundle] pathForResource:@"No01-25" ofType:@"png"];
    UIImage *theImage25 = [UIImage imageWithContentsOfFile:imagePath25];

    NSString *imagePath30 = [[NSBundle mainBundle] pathForResource:@"No01-30" ofType:@"png"];
    UIImage *theImage30 = [UIImage imageWithContentsOfFile:imagePath30];

    img.image = theImage;
    img15.image = theImage15;
    img20.image = theImage20;
    img25.image = theImage25;
    img30.image = theImage30;
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
}

@end
