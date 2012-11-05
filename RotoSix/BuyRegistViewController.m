//
//  BuyRegistViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyRegistViewController.h"

@interface BuyRegistViewController ()

@property (nonatomic, strong) NumberSelectViewController *numberSelViewController;

@end

@implementation BuyRegistViewController

@synthesize numberSelViewController=_numberSelViewController;
@synthesize listData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *array = [[NSArray alloc] initWithObjects:@"新規追加", nil];
    
    self.listData = array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"購入回数";
            break;
        case 1:
            title = @"購入番号";
            break;
        default:
            break;
    }
    return title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (1 == indexPath.section);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return 1;
    NSLog(@"BuyRegist numberOfRowsInSection [%d]", 1);
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    UITableViewCell *cell;
    
    int buySetNo = -1;
    
    CGFloat x = 10.0;
    CGFloat y = 2.0;
    CGFloat width = 23.0;
    CGFloat height = 23.0;
    
    CellIdentifier = @"CellBuyNumberRegist";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    buySetNo = indexPath.row;
    
    switch (indexPath.section) {
        case 0:
            NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
            CellIdentifier = @"CellNewRegistSection00";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
                if (1==1) {
                    UILabel *lbl;

                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:11.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor grayColor];
                    lbl.text = @"ここをタップして";
                    [cell.contentView addSubview:lbl];
                    
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:11.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor grayColor];
                    lbl.text = @"回数を選択して下さい";
                    [cell.contentView addSubview:lbl];
                }
                else {
                    x = 10.0;
                    y = 2.0;
                    width = 35.0;
                    height = 35.0;
                    
                    for (int idx=0; idx < 7; idx++) {
                        //[arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                        img.tag = idx+1;
                        x = x + 39.0;
                        //[cell.contentView addSubview:[arrmBuyNo objectAtIndex:idx]];
                        [cell.contentView addSubview:img];
                    }
                }
            }
            
            break;
        case 1:
            CellIdentifier = @"CellNewRegistSection01";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            buySetNo = indexPath.row;
            
            if (cell==nil) {
                NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
                if (1==1) {
                    UILabel *lbl;
                    
                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:11.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor grayColor];
                    lbl.text = @"ここをタップして";
                    [cell.contentView addSubview:lbl];

                    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 35)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.font = [UIFont systemFontOfSize:11.0];
                    lbl.textAlignment = UITextAlignmentCenter;
                    lbl.textColor = [UIColor grayColor];
                    lbl.text = @"購入した番号を入力して下さい";
                    [cell.contentView addSubview:lbl];
                }
                else {
                    x = 10.0;
                    y = 2.0;
                    width = 23.0;
                    height = 23.0;
                    
                    int idx=0;
                    for (idx=0; idx < 6; idx++) {
                        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                        //[arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                        img.tag = idx+1;
                        x = x + 26;
                        [cell.contentView addSubview:img];
                        //[cell.contentView addSubview:[arrmBuyNo objectAtIndex:idx]];
                    }
                    
                    // ステータスの表示用
                    x = x + 26;
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    //[arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
                    //[cell.contentView addSubview:[arrmBuyNo objectAtIndex:6]];
                    img.tag = idx+1;
                    [cell.contentView addSubview:img];
                }
            }
            
            break;
        default:
            //cellText = @"DEFAULT";
            break;
    }

    if (cell==nil) {
        NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        x = 10.0;
        y = 2.0;
        width = 23.0;
        height = 23.0;
        
        int idx=0;
        for (idx=0; idx < 6; idx++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            //[arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
            img.tag = idx+1;
            x = x + 26;
            [cell.contentView addSubview:img];
            //[cell.contentView addSubview:[arrmBuyNo objectAtIndex:idx]];
        }
        
        // ステータスの表示用
        x = x + 26;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        //[arrmBuyNo addObject:[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)]];
        //[cell.contentView addSubview:[arrmBuyNo objectAtIndex:6]];
        img.tag = idx+1;
        [cell.contentView addSubview:img];
    }
    
    //NSString *setNo = [buyHist getSetNo:buySetNo];
    NSString *setNo = @"";
    
    NSArray *arrBuySingleNo = [setNo componentsSeparatedByString:@","];
    
    for (int idx=0; idx < [arrBuySingleNo count]; idx++) {
        NSString *strNo = [arrBuySingleNo objectAtIndex:idx];
        NSString *imageNoName = [NSString stringWithFormat:@"No%02d-45", [strNo intValue]];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNoName ofType:@"png"];
        UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
        
        UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idx+1];
        img.image = theImage;
        //NSLog(@"cell Sec01 idx[%d]", idx);
    }
        
    return cell;
}

#pragma mark - Item Action Method
- (IBAction)btnCancelPress:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"NumberInput"]) {
        
        //NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        NumberSelectViewController *numInputlViewController = [segue destinationViewController];
        numInputlViewController.buyNumbers = @"";
//        numInputlViewController.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1) {
        return;
    }
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@" cell [%p]", cell);
    NSLog(@"indexPath row [%d] section [%d]", indexPath.row, indexPath.section);
    
    if (indexPath.section==1) {
//        selBuyNumbers = [buyHist getSetNo:indexPath.row];
//        selBuyNo = indexPath.row;
    }
    
    [self performSegueWithIdentifier:@"NumberInput" sender:self];
}


@end
