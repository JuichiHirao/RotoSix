//
//  LotteryViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/28.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "LotteryViewController.h"
#import "Lottery.h"
#import "LotteryDataController.h"
#import "LotteryConnectionHandler.h"
#import "SBJson.h"
#import "BuyHistDataController.h"
#import "BuyHistDetailViewController.h"

@interface LotteryViewController () <SBJsonStreamParserAdapterDelegate>

@end

@implementation LotteryViewController

@synthesize lotteryView;
@synthesize dataController;

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

    dataController = [[LotteryDataController alloc] init];
    [dataController createDemoFromDb];
    NSLog(@"viewDidLoad [%d]", [dataController countOfList]);
    
    lotteryView.backgroundColor = [UIColor clearColor];
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(121.0, 3.0, 15.0, 15.0)];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    imgBg.image = theImage;
    
    lotteryView.backgroundView = imgBg;
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
    //NSLog(@"numberOfRowsInSection [%d]", [dataController countOfList]);
    return [dataController countOfList];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LotteryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *lbKaisuu, *lbLotteryDate;
    UIImage *rowBackground;
    
    Lottery *lotteryAtIndex = [dataController objectInListAtIndex:indexPath.row];
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

#pragma mark SBJsonStreamParserAdapterDelegate methods

// OBJECTが2つ以上の場合は、このdelegateが呼ばれる
- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
    //[NSException raise:@"unexpected" format:@"Should not get here"];
    
    NSLog(@"array受信 JSONRepresentation [%@]", [array JSONRepresentation]);
    
    int updateRow = 0;
    NSEnumerator* data = [array objectEnumerator];
    NSDictionary* item;
    while (item = (NSDictionary*)[data nextObject]) {
        Lottery *lottery = [LotteryDataController getDataFromJson:item];
        
        Lottery *chkLottery = [LotteryDataController getTimes:lottery.times];
        
        if (chkLottery != nil) {
            NSLog(@"already regist times %d", lottery.times);
            continue;
        }
        
        NSMutableArray *arrBuyHist = [BuyHistDataController getTimes:lottery.times];
        for (int idx=0; idx < [arrBuyHist count]; idx++) {
            BuyHistory *data = arrBuyHist[idx];
            [data lotteryCheck:lottery];
        }
        NSLog(@"change times %d", lottery.times);
        [lottery save];
        updateRow++;
    }
    
    if (updateRow > 0) {
        // 更新された情報を含めて全て取り直す
        [dataController createDemoFromDb];

        // セクションを全て更新（各種のデリゲートメソッドも再実行される heightForRowAtIndexPath,numberOfRowsInSection etc...）
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [lotteryView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    self.view.userInteractionEnabled=YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    _indicator.hidden = YES;
}

// OBJECTが1つの場合は、このdelegateが呼ばれる
- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
	NSString *times = [dict objectForKey:@"times"];
    
    NSLog(@"dict受信 times %@   JSONRepresentation [%@]", times, [dict JSONRepresentation]);
    
    self.view.userInteractionEnabled=YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    _indicator.hidden = YES;
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
}

- (void)viewDidUnload {
    [self setLotteryView:nil];
    [self setTabitemRefresh:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
}

- (IBAction)tabitemRefreshPress:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://192.168.11.119:3000/lotteries/"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//	[request setValue:@"application/xml"forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"GET"];
    
    // We don't want *all* the individual messages from the
	// SBJsonStreamParser, just the top-level objects. The stream
	// parser adapter exists for this purpose.
	adapter = [[SBJsonStreamParserAdapter alloc] init];
	
	// Set ourselves as the delegate, so we receive the messages
	// from the adapter.
	adapter.delegate = self;
	
	// Create a new stream parser..
	parser = [[SBJsonStreamParser alloc] init];
	
	// .. and set our adapter as its delegate.
	parser.delegate = adapter;
	
	// Normally it's an error if JSON is followed by anything but
	// whitespace. Setting this means that the parser will be
	// expecting the stream to contain multiple whitespace-separated
	// JSON documents.
	parser.supportMultipleDocuments = YES;
    
    //UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //[self.view addSubview:indicator];
    
    // 画面の中央に表示するようにframeを変更する
    float w = _indicator.frame.size.width;
    float h = _indicator.frame.size.height;
    float x =self.view.frame.size.width/2- w/2;
    float y =self.view.frame.size.height/2- h/2;
    _indicator.frame =CGRectMake(x, y, w, h);
    
    self.view.userInteractionEnabled=NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
	//UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    //[grayView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    //[self.view addSubview:grayView];

    [_indicator startAnimating];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

// サーバからレスポンスヘッダを受け取ったときに呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// 送信されるデータの文字コードを取得
	NSString *encodingName = [response textEncodingName];
	
	NSLog(@"受信文字コード: %@", encodingName);
    
    int statusCode = [((NSHTTPURLResponse *)response) statusCode];
    
    if (statusCode >= 400) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"サービスエラー" message:@"サーバ側の当選情報の取得機能が有効ではありません" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
        [alert show];
        
        return;
    }
	if ([encodingName isEqualToString: @"euc-jp"]) {
		receivedDataEncoding = NSJapaneseEUCStringEncoding;
	} else {
		receivedDataEncoding = NSUTF8StringEncoding;
	}
    
    return;
}

// サーバからデータを受け取るたびに呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// 取得したデータをreceivedDataへ格納する
	NSLog(@"受信データ（バイト数）: %d", [data length]);
	//[receivedData appendData:data];
    
    SBJsonStreamParserStatus status = [parser parse:data];
	
	if (status == SBJsonStreamParserError) {
        //tweet.text = [NSString stringWithFormat: @"The parser encountered an error: %@", parser.error];
		NSLog(@"Parser error: %@", parser.error);
		
	} else if (status == SBJsonStreamParserWaitingForData) {
		NSLog(@"Parser waiting for more data");
	}
	NSLog(@"SBJsonStreamParserStatus");
}

// データの取得が終了したときに呼び出される
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *result = [[NSString alloc] initWithData:receivedData encoding:receivedDataEncoding];
	NSLog(@"データの受信完了: %@", result);
	//[result release];
	//[receivedData release];
}

// 接続でエラーが発生した場合に呼び出される
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
    NSLog(@"Connection failed! Error - %@ %d %@",
          [error domain],
          [error code],
          [error localizedDescription]);
    
    [_indicator stopAnimating];
    self.view.userInteractionEnabled=YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    _indicator.hidden = YES;
    
    //ネットワークに接続されていない時
    if([error code] ==  NSURLErrorNotConnectedToInternet){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接続エラー" message:@"ネットワークの接続ができません" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
        [alert show];

        return;
    }
    //サーバ側が起動していない場合
    if([error code] == NSURLErrorCannotConnectToHost){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接続エラー" message:@"接続先が有効ではありません" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
        [alert show];
        
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接続エラー" message:@"接続できません" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
    [alert show];
}

#pragma mark Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"BuyHistDetail"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        BuyHistDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.lottery = [dataController objectInListAtIndex:selectedRowIndex.row];
    }
}

// アクセサリタイプがタップされた場合も行の選択と同じ動作をする（詳細画面へ遷移）
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"BuyHistDetail" sender:self];
}


@end
