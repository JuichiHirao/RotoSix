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
    
    //NSArray* arr = [feed objectForKey:@"link"];
    NSEnumerator* data = [array objectEnumerator];
    NSDictionary* item;
    while (item = (NSDictionary*)[data nextObject]) {
        Lottery *lottery = [LotteryDataController getDataFromJson:item];
        NSLog(@"change times %d", lottery.times);
        [lottery save];
    }
}

// OBJECTが1つの場合は、このdelegateが呼ばれる
- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
	NSString *times = [dict objectForKey:@"times"];
    
    NSLog(@"dict受信 times %@   JSONRepresentation [%@]", times, [dict JSONRepresentation]);
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
    [super viewDidUnload];
}

- (IBAction)tabitemRefreshPress:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/lotteries/"];
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
    
	[NSURLConnection connectionWithRequest:request delegate:self];
}

// サーバからレスポンスヘッダを受け取ったときに呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// 送信されるデータの文字コードを取得
	NSString *encodingName = [response textEncodingName];
	
	NSLog(@"受信文字コード: %@", encodingName);
	
	if ([encodingName isEqualToString: @"euc-jp"]) {
		receivedDataEncoding = NSJapaneseEUCStringEncoding;
	} else {
		receivedDataEncoding = NSUTF8StringEncoding;
	}
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

@end
