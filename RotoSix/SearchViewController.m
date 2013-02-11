//
//  SearchViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/11.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import "SearchViewController.h"
#import "LotteryDataController.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) NumberSelectViewController *numberSelViewController;

@end

@implementation SearchViewController

@synthesize numberSelViewController=_numberSelViewController;

#pragma mark - from SelectView Delegate
-(void)NumberSelectBtnEnd:(NumberSelectViewController *)controller SelectNumber:(NSString *)name {
    
    NSLog(@"NumberSelectBtnEnd name [%@]", name );
    Lottery *data = [LotteryDataController getSearchNumSet:name];
    
    if (data!=nil) {
        NSLog(@"Search Match!! [%d]", data.times);
        [self performSegueWithIdentifier:@"SearchResult" sender:self];
    }
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    if (section == 0) {
        return 1;
    }
    else {
        return 2;
    }
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    switch (indexPath.section) {
        case 0:
            height = 50.0;
            break;
        case 1:
            height = 35.0;
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
            //CellIdentifier = @"CellBuyHistDetailSection00";
            //cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            //if (cell == nil) {
            //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //}
            // 保存ボタン
            UIButton *btn;
            btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(10,5,300,40);
            [btn setTitle:@"検索する番号の選択" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnSelectSearchNumberPress) forControlEvents:UIControlEventTouchUpInside];
            //btn.tag = 101;
            [cell.contentView addSubview:btn];
            
            break;
    }
    //NSString *imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
    //rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
    //((UIImageView *)cell.backgroundView).image = rowBackground;
    /*
     if (indexPath.section==0) {
     NSArray *arrLotteryNo = [@"1,2,8,16,25,40,27" componentsSeparatedByString:@","];
     
     for (int idx=0; idx < 7; idx++) {
     NSString *strNo = [arrLotteryNo objectAtIndex:idx];
     NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
     NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
     UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
     
     UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idx+1];
     img.image = theImage;
     }
     }
     */
    // Configure the cell...
    
    return cell;
}

- (void)btnSelectSearchNumberPress {
    
    [self performSegueWithIdentifier:@"NumberInput" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"NumberInput"]) {
        
        //NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        NumberSelectViewController *numInputlViewController = [segue destinationViewController];
        numInputlViewController.buyNumbers = @"";
        numInputlViewController.delegate = self;
    }
    else {
        SearchResultViewController *searchResultViewController = [segue destinationViewController];
        searchResultViewController.selNumSet = @"";
        //searchResultViewController.delegate = self;
    }
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
