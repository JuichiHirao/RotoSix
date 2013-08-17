//
//  NumberSelectViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/09.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayerNumberSelect.h"
#import "NumberSelectView.h"
#import "BuyHistory.h"
#import "QuartzTextNumDelegate.h"

@protocol NumberSelectDelegate;

@interface NumberSelectViewController : UIViewController {
//    UIView *selpanelView;
    NumberSelectView *selpanelView;
    NSInteger selectNoCount;
    id <NumberSelectDelegate> delegate;
    bool isAnimation;
    bool isPaste;
    NSInteger pasteNumCount;
    
    QuartzTextNumDelegate *_layerDelegate;
}

@property (nonatomic, strong) NSString *buyNumbers;
@property (nonatomic) NSInteger minSelNum;
@property (nonatomic) NSInteger maxSelNum;
@property (nonatomic, strong) UILabel *lblNotice;
@property (weak, nonatomic) id <NumberSelectDelegate> delegate;

@end

@protocol NumberSelectDelegate <NSObject>

- (void)NumberSelectBtnEnd:(NumberSelectViewController *)controller SelectNumber:(NSString *)name;

@end
