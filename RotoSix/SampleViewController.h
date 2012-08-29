//
//  SampleViewController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/08/18.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleViewController : UIViewController
- (IBAction)button1Action:(id)sender;
- (IBAction)button2Action:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *label1;

@end
