//
//  BuyTimesSelectViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/11/07.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyTimesSelectViewController : UIViewController
    <UIPickerViewDataSource, UIPickerViewDelegate> {
        
    UIPickerView *picker;
}

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)btnCancelPressed:(id)sender;

@end
