//
//  NumberSelectViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/09.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayerNumberSelect.h"

@interface NumberSelectViewController : UIViewController {
    UIView *selpanelView;
}

@property (nonatomic, strong) NSString *buyNumbers;

- (void)btnEndPressed;

@end
