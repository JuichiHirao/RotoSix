//
//  UseModalViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/05/06.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import "UseModalTableViewController.h"
#import "AppDelegate.h"

@interface UseModalTableViewController ()

@end

@implementation UseModalTableViewController

#pragma mark - Modal View Method
- (void) showModal:(UIView *) modalView
{
    UIWindow *mainWindow = (((AppDelegate *) [UIApplication sharedApplication].delegate).window);
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    modalView.center = offScreenCenter;
    
    [mainWindow addSubview:modalView];
    
    UIImageView *imgview = (UIImageView *)[self.view viewWithTag:99];

    if (imgview == nil) {
        // 黒の空画像を生成してalpha値を変えることによりmodalの背景とする
        CGRect blackImageFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contextRef, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor);
        CGContextFillRect(contextRef, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:blackImageFrame];
        imgview.image = img;
        imgview.tag = 99;
        imgview.hidden = NO;
        [self.view addSubview:imgview];
        
        [UIView animateWithDuration:2.0f animations:^{
            //imgview.alpha = 0.7; // 正常に動作しないので後回し
            modalView.center = middleCenter;
        }];
    }
    else {
        // 黒の空画像が既に生成されていた場合はtagから取得
        UIImageView *imgview = (UIImageView *)[self.view viewWithTag:99];
        imgview.alpha = 0.6;
        imgview.hidden = NO;
        
        [UIView animateWithDuration:0.5f animations:^{
            modalView.center = middleCenter;
        }];
    }    
}

- (void) hideModal:(UIView*) modalView
{
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    
    UIImageView *imgview = (UIImageView *)[self.view viewWithTag:99];
    [UIView animateWithDuration:0.5f animations:^{
        modalView.center = offScreenCenter;
    }];

    // 黒画像を非表示にする
    imgview.hidden = YES;
}

- (void) showModalBuyTimesSelect:(NSArray *)arrLottery {

    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    buyTimesSelectViewController = [myStoryBoard instantiateViewControllerWithIdentifier:@"BuyTimesSelect"];
    buyTimesSelectViewController.delegate = self;
    buyTimesSelectViewController.arrLottery = arrLottery;

    [self showModal:buyTimesSelectViewController.view];
}

- (void) showModalNumberInput:(NSString *)selNumbers {
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    numberSelectViewController = [myStoryBoard instantiateViewControllerWithIdentifier:@"NumberSelect"];
    numberSelectViewController.delegate = self;
    numberSelectViewController.buyNumbers = selNumbers;
    
    [self showModal:numberSelectViewController.view];
}

- (void) showModalNumberInput:(NSString *)selNumbers MinSelectNumber:(NSInteger)minSelNum MaxSelectNumber:(NSInteger)maxSelNum {
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    numberSelectViewController = [myStoryBoard instantiateViewControllerWithIdentifier:@"NumberSelect"];
    numberSelectViewController.delegate = self;
    numberSelectViewController.buyNumbers = selNumbers;
    numberSelectViewController.minSelNum = minSelNum;
    numberSelectViewController.maxSelNum = maxSelNum;
    
    [self showModal:numberSelectViewController.view];
}

@end
