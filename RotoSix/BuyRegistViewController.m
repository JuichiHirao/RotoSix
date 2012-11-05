//
//  BuyRegistViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyRegistViewController.h"

@interface BuyRegistViewController ()

@end

@implementation BuyRegistViewController

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
    [self setBtnCancel:nil];
    [self setTableViewBuyNumber:nil];
    [super viewDidUnload];
}

- (IBAction)btnCancelPress:(id)sender {
    [self dismissModalViewControllerAnimated:YES];

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
    
    if (cell==nil) {
        NSLog(@"cell nil CellIdentifier [%@] [%p]", CellIdentifier, cell);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
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

@end
