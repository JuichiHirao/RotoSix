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

@interface NumberSelectViewController : UIViewController {
//    UIView *selpanelView;
    NumberSelectView *selpanelView;
    NSInteger selectNoCount;
}

@property (nonatomic, strong) NSString *buyNumbers;
@property (nonatomic, strong) UILabel *lblNotice;

- (void)btnCancelPresed;
- (void)btnEndPressed;

@end
