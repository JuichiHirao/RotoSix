//
//  BuyHistoryViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/08/27.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "BuyHistoryViewController.h"
#import "BuyHistDetailViewController.h"
#import "BuyHistDataController.h"
#import "BuyHistory.h"
#import "BuyRegistViewController.h"
#import "QuartzTextNumDelegate.h"

@interface BuyHistoryViewController ()

@property (nonatomic, strong) BuyRegistViewController *buyRegistViewController;

@end

@implementation BuyHistoryViewController

@synthesize buyRegistViewController=_buyRegistViewController;

@synthesize dataController;
@synthesize histTableView;
@synthesize buyHistCell;

#pragma mark - Delegate From Other Display

- (void)RegistBuyHistoryEnd {
    NSLog(@"RegistBuyHistoryEnd");
    [dataController loadAll];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [histTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UIView Override Method

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {

    // super viewWillAppearをcallするとindexPathForSelectedRowがクリアされるので、その前に取得
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    NSLog(@"viewWillAppear animated[%d] row [%d]", animated, selectedRowIndex.row);
    
    [super viewWillAppear:animated];
    
    if ([dataController countOfList] > 0) {
        // 更新した行だけをリロード、セル再表示する
        //if ([dataController isDbUpdate:selectedRowIndex.row]) {
            [dataController reload:selectedRowIndex.row];
            
            NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:selectedRowIndex.row inSection:0];
            NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [histTableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [dataController setDbUpdate:selectedRowIndex.row];
        //}
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    BuyHistDataController *data = [[BuyHistDataController alloc] init];
    dataController = data;
    NSLog(@"viewDidLoad [%d]", [dataController countOfList]);
    //[data createDemoFromDb];

    histTableView.backgroundColor = [UIColor clearColor];
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 3.0, 15.0, 15.0)];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    imgBg.image = theImage;

    histTableView.backgroundView = imgBg;
    
    isCellSetting = NO;
    
    marrQuartzTextDelegate = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [self setHistTableView:nil];
    [self setBuyHistCell:nil];
    [self setTabitemDisplaySetting:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [dataController removeObjectInListAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection [%d]", [dataController countOfList]);
    return [dataController countOfList];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuyHistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *lbKaisuu, *lbLotteryDate;
    UIImage *rowBackground;
    
    BuyHistory *buyHistAtIndex = [dataController objectInListAtIndex:indexPath.row];
    UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:1];

    NSInteger idxImgTag, idxImgPlaceTag;
    if (lbl==nil) {
        //NSLog(@"cell create");
        
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

        CGFloat x = 204.5; //126.0;
        CGFloat y = 13.0;

        for (int idx=0; idx < 5; idx++ ) {
            
            CALayer *layerNum = [CALayer layer];
            //layerNum.needsDisplayOnBoundsChange = YES;
            layerNum.bounds = CGRectMake(0, 0, 157.0, 20.0);
            layerNum.name = [NSString stringWithFormat:@"NumRow%02d", idx+1];
            layerNum.position = CGPointMake(x, y);
            
            CGAffineTransform t = CGAffineTransformMake(1.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f);
            layerNum.affineTransform = t;
            layerNum.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BgSelectNumber157"]].CGColor;
            layerNum.opacity = YES;

            [cell.contentView.layer addSublayer:layerNum];
            y = y + 22;
        }

        idxImgPlaceTag = 101;
        y = 3.0;
        for (int idx=0; idx < 5; idx++ ) {
            x = 103.0;
            
            //NSLog(@"idxImgPlaceTag %d x [%f] y [%f]", idxImgPlaceTag, x, y);
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
            img.tag = idxImgPlaceTag;
            
            [cell.contentView addSubview:img];
            idxImgPlaceTag++;
            y = y + 22;
        }

        cell.backgroundView = [[UIImageView alloc] init];
    }
    else {
        lbLotteryDate = (UILabel*)[cell.contentView viewWithTag:1];
        lbKaisuu = (UILabel*)[cell.contentView viewWithTag:2];
        
        UIImageView *img;
        for (idxImgTag = 11; idxImgTag <= 40; idxImgTag++) {
            img = (UIImageView*)[cell.contentView viewWithTag:idxImgTag];

            if (img==nil) {
                break;
            }
            img.image = nil;
        }
    }
    
    NSString *imageCellBgPath = [[NSBundle mainBundle] pathForResource:@"CellBackground" ofType:@"png"];
    rowBackground = [UIImage imageWithContentsOfFile:imageCellBgPath];
    
    ((UIImageView *)cell.backgroundView).image = rowBackground;

    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"yyyy年MM月dd日";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
    lbLotteryDate.text = [outputDateFormatter stringFromDate:buyHistAtIndex.lotteryDate];
    
    lbKaisuu.text = [NSString stringWithFormat:@"第%d回", buyHistAtIndex.lotteryTimes];      // @"第689回";
    //NSLog(@"cellForRowAtIndexPath sec[%d] row[%d]  buyHist.lotteryTimes [%d]   lbLotteryDate.text [%@] status [%d]"
    //      , indexPath.section, indexPath.row, buyHistAtIndex.lotteryTimes, [outputDateFormatter stringFromDate:buyHistAtIndex.lotteryDate], buyHistAtIndex.lotteryStatus);

    // 当選結果画像の表示
    idxImgPlaceTag = 101;
    if (buyHistAtIndex.lotteryStatus == 1) {
        for (int idxBuySet=0; idxBuySet<5; idxBuySet++) {
            NSString *setNo = [buyHistAtIndex getSetNo:idxBuySet];
            
            if ([setNo length] <= 0) {
                UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idxImgPlaceTag];
                img.image = nil;
                idxImgPlaceTag++;
                continue;
            }
            
            NSString *imgName = [buyHistAtIndex getPlaceImageName:[buyHistAtIndex getPlace:idxBuySet]];
            //NSLog(@"getPlaceImageName place [%@] ", imgName);
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
            UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idxImgPlaceTag];
            
            img.image = theImage;
            idxImgPlaceTag++;
        }
    }
    else {
        for (int idxBuySet=0; idxBuySet<5; idxBuySet++) {
            UIImageView *img = (UIImageView*)[cell.contentView viewWithTag:idxImgPlaceTag];
            img.image = nil;
            idxImgPlaceTag++;
        }
    }

    for (int idxBuySet=0; idxBuySet<5; idxBuySet++) {
        NSString *setNo = [buyHistAtIndex getSetNo:idxBuySet];
        
        CALayer *findlayer = [self layerForName:[NSString stringWithFormat:@"NumRow%02d", idxBuySet+1] Cell:cell];

        if ([setNo length] <= 0) {
            findlayer.hidden = YES;
            continue;
        }

        if (findlayer == nil) {
            //NSLog(@"%@", [NSString stringWithFormat:@"not findlayer %@", [NSString stringWithFormat:@"NumRow%02d", idxBuySet+1]]);
            continue;
        }
        //NSLog(@"%@", [NSString stringWithFormat:@"findlayer %@", [NSString stringWithFormat:@"NumRow%02d", idxBuySet+1]]);

        QuartzTextNumDelegate* _layerDelegate = [[QuartzTextNumDelegate alloc] init];
        _layerDelegate.strNum = setNo;
        
        NSLog(@"%@", [NSString stringWithFormat:@"findlayer %@", [NSString stringWithFormat:@"setNo %@", setNo]]);
        
        [marrQuartzTextDelegate addObject:_layerDelegate];

        findlayer.delegate = _layerDelegate;
        [findlayer setNeedsDisplay];
    }

    return cell;
}

- (CALayer *)layerForName:(NSString *)name Cell:(UITableViewCell *)cell
{
	for(CALayer *layer in cell.contentView.layer.sublayers) {
        //NSLog(@"%@", [NSString stringWithFormat:@"layer.name %@", [layer name]]);
		if([[layer name] isEqualToString:name]) {
			return layer;
		}
	}
    
	return nil;
}

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
    //[self performSegueWithIdentifier:@"BuyHistDetail" sender:self];
}

#pragma mark Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"BuyHistDetail"]) {
        NSIndexPath *selectedRowIndex;
        if ([sender isKindOfClass:[NSIndexPath self]]) {
            selectedRowIndex = (NSIndexPath *)sender;
        }
        else {
            selectedRowIndex = [self.tableView indexPathForSelectedRow];
        }
        BuyHistDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.buyHist= [dataController objectInListAtIndex:selectedRowIndex.row];
    }
    else if ([[segue identifier] isEqualToString:@"BuyRegist"]) {
        BuyRegistViewController *buyRegistViewController = [segue destinationViewController];
        buyRegistViewController.delegate = self;
    }
}

// アクセサリタイプがタップされた場合も行の選択と同じ動作をする（詳細画面へ遷移）
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"BuyHistDetail" sender:indexPath];
}

- (IBAction)tabitemDisplaySettingPress:(id)sender {

    //TableDisplaySetting *dispSetting = (TableDisplaySetting*)[self viewWithTagNotCountingSelf:201];
    TableDisplaySetting *dispSetting = (TableDisplaySetting*)[self.view viewWithTag:201];

    /*
    CALayer *layer = [self getDisplaySettingLayer];
    
    if (layer != nil) {
        BOOL bHidden = layer.hidden;
        
        if (bHidden == YES)
            layer.hidden = NO;
        else
            layer.hidden = YES;

        return;
    }
    
    LayerTableDisplaySetting *selpanel = [LayerTableDisplaySetting layer];
    //selpanel.bounds = CGRectMake(0, 0, 300, 340);
    selpanel.name = @"DisplaySetting";
    selpanel.frame = CGRectMake(0, 0, 190.5, 110);
    selpanel.position = CGPointMake(160, 200); // posY <-- iPhone5 : 284(568/2) + 59(568/2-panelSizeY/2) =  343, other 240 + 15 = 255
    //selpanel.backgroundColor = [UIColor clearColor].CGColor;
    selpanel.backgroundColor = [UIColor whiteColor].CGColor;
    //selpanel.opacity = 0.5;
    //selpanel.opacity = YES;
    
    [selpanel setNeedsDisplay];
    [self.view.layer addSublayer:selpanel];

     */

    if (dispSetting == nil) {
        dispSetting = [[TableDisplaySetting alloc] initWithFrame:self.view.window.bounds];
        //    TableDisplaySetting *dispSetting = [[TableDisplaySetting alloc] initWithFrame:self.view.window.bounds CGRectMake(10, 10, 180, 100)];
        dispSetting.tag = 201;
        [self.view addSubview:dispSetting];
    }
    else {
        BOOL bHidden = dispSetting.hidden;
        
        if (bHidden == YES)
            dispSetting.hidden = NO;
        else
            dispSetting.hidden = YES;
        
        return;
    }
    
//    TableDisplaySetting *dispSetting = [[TableDisplaySetting alloc] initWithFrame:self.view.window.bounds];
//    TableDisplaySetting *dispSetting = [[TableDisplaySetting alloc] initWithFrame:self.view.window.bounds CGRectMake(10, 10, 180, 100)];
//    [dispSetting viewWithTag:201];
//    [self.view addSubview:dispSetting];
//    self.window.rootViewController.view = [[[bubbleView alloc] initWithFrame:self.window.bounds] autorelease];
//    [self showModalTableDisplaySetting];
}

- (UIView *)viewWithTagNotCountingSelf:(NSInteger)tag
{
    UIView *toReturn = nil;
    
    for (UIView *subView in self.view.subviews)
    {
        toReturn = [subView viewWithTag:tag];
        
        if (toReturn)
            break;
    }
    
    return toReturn;
}

- (void) displaySetting
{

}

- (CALayer *)getDisplaySettingLayer
{
	for(CALayer *layer in self.view.layer.sublayers) {
		if([[layer name] isEqualToString:@"DisplaySetting"]) {
            return layer;
		}
	}
    
	return nil;
}

@end
