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

@protocol NumberSelectDelegate;

@interface NumberSelectViewController : UIViewController {
//    UIView *selpanelView;
    NumberSelectView *selpanelView;
    NSInteger selectNoCount;
    id <NumberSelectDelegate> delegate;
}

@property (nonatomic, strong) NSString *buyNumbers;
@property (nonatomic) NSInteger minSelNum;
@property (nonatomic) NSInteger maxSelNum;
@property (nonatomic, strong) UILabel *lblNotice;
@property (weak, nonatomic) id <NumberSelectDelegate> delegate;

- (void)btnCancelPresed;
- (void)btnEndPressed;

@end

@protocol NumberSelectDelegate <NSObject>

- (void)NumberSelectBtnEnd:(NumberSelectViewController *)controller SelectNumber:(NSString *)name;

@end
