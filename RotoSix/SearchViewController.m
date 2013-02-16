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
    
    NSLog(@"NumberSelectBtnEnd name [%@]", name );
//    NSMutableArray *arrData = [LotteryDataController getSearchNumSet:name];

    if (selSearch == nil) {
        selSearch = [[Search alloc] init];
    }
    
    selSearch.num_set = name;
    [self performSegueWithIdentifier:@"SearchResult" sender:self];
}

- (void)RegistSearchEnd {
    NSLog(@"RegistSearchEnd");
    [dataController load];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return [dataController countOfList];
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
            height = 50.0;
            break;
        default:
            break;
    }
    return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return NO;
    else
        return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    UITableViewCell *cell;
    
    UILabel *lbMatchCount, *lbCreateDate;
    UIImage *rowBackground;
    Search *searchAtIndex;
    NSInteger idxImgTag;

    switch (indexPath.section) {
        case 0:
        {
            CellIdentifier = @"CellSearchSec00";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);

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
        case 1:
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
                
                CGFloat x = 10.0;
                CGFloat y = 15.0;
                CGFloat width = 30.0;
                CGFloat height = 30.0;
                
                idxImgTag = 11;
                for (int idxSub=0; idxSub < 6; idxSub++) {
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    img.tag = idxImgTag;
                    x = x + 45;
                    
                    [cell.contentView addSubview:img];
                    idxImgTag++;
                }
                
                cell.backgroundView = [[UIImageView alloc] init];
            }
            else {
                lbCreateDate = (UILabel*)[cell.contentView viewWithTag:1];
                lbMatchCount = (UILabel*)[cell.contentView viewWithTag:2];
                
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
        case 1:
            imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
            rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
            
            ((UIImageView *)cell.backgroundView).image = rowBackground;
            
            NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
            NSString *outputDateFormatterStr = @"yyyy-MM-dd HH:mm:dd";
            [outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
            [outputDateFormatter setDateFormat:outputDateFormatterStr];
            lbCreateDate.text = [outputDateFormatter stringFromDate:searchAtIndex.registDate];
            
            lbMatchCount.text = [NSString stringWithFormat:@"%d", searchAtIndex.matchCount];
            NSLog(@"cellForRowAtIndexPath sec[%d] row[%d] search.num_set [%@]  search.matchCount [%d]   lbLotteryDate.text [%@]"
                  , indexPath.section, indexPath.row, searchAtIndex.num_set, searchAtIndex.matchCount, [outputDateFormatter stringFromDate:searchAtIndex.registDate]);
            
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

- (void)btnSelectSearchNumberPress {
    
    [self performSegueWithIdentifier:@"NumberInput" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"NumberInput"]) {
        
        //NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        NumberSelectViewController *numInputlViewController = [segue destinationViewController];
        numInputlViewController.buyNumbers = @"";
        numInputlViewController.minSelNum = 4;
        numInputlViewController.maxSelNum = 6;
        numInputlViewController.delegate = self;
    }
    else {
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

@end
