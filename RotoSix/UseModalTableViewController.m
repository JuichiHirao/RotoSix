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
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    modalView.center = middleCenter;
    [UIView commitAnimations];
    self.view.alpha = 0.8f;
}

- (void) hideModal:(UIView*) modalView
{
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    [UIView beginAnimations:nil context:(__bridge_retained void *)(modalView)];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    modalView.center = offScreenCenter;
    [UIView commitAnimations];
    self.view.alpha = 1.0f;
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
