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
#import "SearchDataController.h"
#import "Search.h"

@interface SearchViewController ()

@property (nonatomic, strong) NumberSelectViewController *numberSelViewController;

@end

@implementation SearchViewController

@synthesize dataController;
@synthesize numberSelViewController=_numberSelViewController;

#pragma mark - from SelectView Delegate
-(void)NumberSelectBtnEnd:(NumberSelectViewController *)controller SelectNumber:(NSString *)name {
    
//    NSMutableArray *arrData = [LotteryDataController getSearchNumSet:name];

    if ([name isEqual:@"Cancel"]) {
        [self hideModal:controller.view];
        return;
    }
    if (selSearch == nil) {
        selSearch = [[Search alloc] init];
    }
    [self hideModal:controller.view];

    selSearch.num_set = name;
    //NSLog(@"NumberSelectBtnEnd selSearch ID [%d]   num_set [%@]", selSearch.dbId, selSearch.num_set );
    [self performSegueWithIdentifier:@"SearchResult" sender:self];
}

- (void)RegistSearchEnd {
    NSLog(@"RegistSearchEnd");
    [dataController load];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    [histTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
    
    SearchDataController *data = [[SearchDataController alloc] init];
    dataController = data;

    self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //[self setEditing:YES animated:YES];
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
    return [dataController countOfList];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [dataController removeObjectInListAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    UITableViewCell *cell;
    
    UILabel *lbMatchCount, *lbCreateDate, *lblTotal, *lblTotalAmount;
    UIImage *rowBackground;
    Search *searchAtIndex;
    NSInteger idxImgTag;

    switch (indexPath.section) {
        case 0:
        {
            searchAtIndex = [dataController objectInListAtIndex:indexPath.row];
            
            CellIdentifier = @"CellSearchSec01";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }

            UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:1];
            
            if (lbl==nil) {
                NSLog(@"cell create");
                
                lbCreateDate = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, 120.0, 15.0)];
                lbCreateDate.tag = 1;
                lbCreateDate.backgroundColor = [UIColor clearColor];
                lbCreateDate.font = [UIFont systemFontOfSize:12.0];
                lbCreateDate.textAlignment = UITextAlignmentLeft;
                lbCreateDate.textColor = [UIColor blackColor];
                
                [cell.contentView addSubview:lbCreateDate];
                
                lbMatchCount = [[UILabel alloc] initWithFrame:CGRectMake(100, 23, 200.0, 20)];
                lbMatchCount.tag = 2;
                lbMatchCount.backgroundColor = [UIColor clearColor];
                lbMatchCount.font = [UIFont systemFontOfSize:20.0];
                lbMatchCount.textAlignment = UITextAlignmentRight;
                lbMatchCount.textColor = [UIColor blackColor];
                
                [cell.contentView addSubview:lbMatchCount];

                lblTotal = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 60.0, 80.0, 20.0)];
                lblTotal.tag = 3;
                lblTotal.backgroundColor = [UIColor clearColor];
                lblTotal.font = [UIFont systemFontOfSize:11.0];
                lblTotal.textAlignment = UITextAlignmentLeft;
                lblTotal.textColor = [UIColor blackColor];
                
                [cell.contentView addSubview:lblTotal];

                lblTotalAmount = [[UILabel alloc] initWithFrame:CGRectMake(140.0, 62.0, 100.0, 15.0)];
                lblTotalAmount.tag = 4;
                lblTotalAmount.backgroundColor = [UIColor clearColor];
                lblTotalAmount.font = [UIFont systemFontOfSize:14.0];
                lblTotalAmount.textAlignment = UITextAlignmentLeft;
                lblTotalAmount.textColor = [UIColor blackColor];
                
                [cell.contentView addSubview:lblTotalAmount];

                UIImageView *imgBestLottery = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 30, 30)];
                imgBestLottery.tag = 5;
                
                [cell.contentView addSubview:imgBestLottery];

                CGFloat x = 10.0;
                CGFloat y = 15.0;
                CGFloat width = 25.0;
                CGFloat height = 25.0;
                
                idxImgTag = 11;
                for (int idxSub=0; idxSub < 6; idxSub++) {
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    img.tag = idxImgTag;
                    x = x + 30;
                    
                    [cell.contentView addSubview:img];
                    idxImgTag++;
                }
                
                cell.backgroundView = [[UIImageView alloc] init];
            }
            else {
                lbCreateDate = (UILabel*)[cell.contentView viewWithTag:1];
                lbMatchCount = (UILabel*)[cell.contentView viewWithTag:2];
                lblTotal = (UILabel*)[cell.contentView viewWithTag:3];
                lblTotalAmount = (UILabel*)[cell.contentView viewWithTag:4];
                
                UIImageView *img;
                for (idxImgTag = 11; idxImgTag <= 40; idxImgTag++) {
                    img = (UIImageView*)[cell.contentView viewWithTag:idxImgTag];
                    
                    if (img==nil) {
                        break;
                    }
                    img.image = nil;
                }
            }
            break;
        }
    }
    
    NSString *imageCellBgPath;
    switch (indexPath.section) {
        case 0:
            imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
            rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
            
            ((UIImageView *)cell.backgroundView).image = rowBackground;
            
            NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
            NSString *outputDateFormatterStr = @"yyyy-MM-dd HH:mm:dd";
            [outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
            [outputDateFormatter setDateFormat:outputDateFormatterStr];
            lbCreateDate.text = [outputDateFormatter stringFromDate:searchAtIndex.registDate];
            
            lbMatchCount.text = [NSString stringWithFormat:@"%d", searchAtIndex.matchCount];

            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[searchAtIndex getBestLotteryImageName] ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            
            UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:5];
            img.image = theImage;
            

            lblTotal.text = @"当選合計金額";
            NSNumberFormatter *fmtNum = [[NSNumberFormatter alloc]init];
            [fmtNum setPositiveFormat:@"###,###,###,##0"];
            NSString *dispText = [NSString stringWithFormat:@"%@円", [fmtNum stringFromNumber:[NSNumber numberWithInt:searchAtIndex.totalAmount]]];
            lblTotalAmount.text = dispText;

            //NSLog(@"cellForRowAtIndexPath sec[%d] row[%d] search.num_set [%@]  search.matchCount [%d]   lbLotteryDate.text [%@]"
            //      , indexPath.section, indexPath.row, searchAtIndex.num_set, searchAtIndex.matchCount, [outputDateFormatter stringFromDate:searchAtIndex.registDate]);
            
            idxImgTag = 11;
            for (int idxBuySet=0; idxBuySet<5; idxBuySet++) {
                NSArray *arrNumSet = [searchAtIndex.num_set componentsSeparatedByString:@","];
                
                for (int idx=0; idx < [arrNumSet count]; idx++) {
                    NSString *strNo = [arrNumSet objectAtIndex:idx];
                    NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
                    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
                    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
                    
                    UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idxImgTag+idx];
                    img.image = theImage;
                }
            }
    }
    
    return cell;
}

- (IBAction)tabitemSearchAddPress:(id)sender {
    selSearch = nil;
    [self showModalNumberInput:@"" MinSelectNumber:4 MaxSelectNumber:6];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"SearchResult"]) {
        SearchResultViewController *searchResultViewController = [segue destinationViewController];
        searchResultViewController.delegate = self;
        searchResultViewController.search = selSearch;
        //searchResultViewController.delegate = self;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selSearch = [dataController objectInListAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SearchResult" sender:self];

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setTabitemSearchAdd:nil];
    [super viewDidUnload];
}

@end
