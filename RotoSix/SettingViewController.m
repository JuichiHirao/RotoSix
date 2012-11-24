//
//  SettingViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/24.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "SettingViewController.h"
#import "DatabaseFileController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize selDefaultRow;

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"LotteryDefault";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"当選情報の初期化、再取得";
        }
        else {
            cell.textLabel.text = @"購入情報の初期化";
        }
    }
    
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

#pragma mark - Alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        return;
    }
    
    if (selDefaultRow == 0) {
        [DatabaseFileController clearMasterFile];
        NSLog(@"DatabaseFileController clearMasterFile実行");
    }
    else {
        [DatabaseFileController clearTranFile];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strMessage;
    if (indexPath.row == 0) {
        strMessage = @"当選情報を削除してネットワークから再取得を行います、宜しいですか？";
    }
    else {
        strMessage = @"これまで入力した購入、当選金額情報は全て削除されます、宜しいですか？";
    }
    selDefaultRow = indexPath.row;
    
    if (strMessage.length > 0) {
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未選択エラー" message:strMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", @"OK", nil ];
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"初期化";
        alert.message = strMessage;
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"OK"];
        alert.cancelButtonIndex = 1;
        [alert show];
        
        return;
    }
}

@end
