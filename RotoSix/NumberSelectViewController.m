//
//  NumberSelectViewController.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/09.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "NumberSelectViewController.h"

@interface NumberSelectViewController ()

@end

@implementation NumberSelectViewController

- (void)loadView {
    selpanelView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    LayerNumberSelect *selpanel = [LayerNumberSelect layer];
    selpanel.bounds = CGRectMake(0, 0, 300, 340);
    selpanel.position = CGPointMake(0, 10);
    
    selpanel.opacity = YES;

    [selpanel setNeedsDisplay];
    [selpanelView.layer addSublayer:selpanel];
    
    //    [self.view clearsContextBeforeDrawing];
    self.view = selpanelView;
}
- (void)viewDidLoad
{
    UIImageView *img1_1, *img1_2, *img1_3, *img1_4, *img1_5, *img1_6;
    img1_1 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 5.0, 45.0, 45.0)];

/*    [super viewDidLoad];
    LayerNumberSelect *selpanel = [LayerNumberSelect layer];
    selpanel.bounds = CGRectMake(0, 0, 300, 340);
    selpanel.position = CGPointMake(0, 10);
    
    selpanelView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    [selpanelView.layer addSublayer:selpanel];
    
//    [self.view clearsContextBeforeDrawing];
    [self.view addSubview:selpanelView];
  */
/*
	// Do any additional setup after loading the view.
    // 決定ボタン
	UIButton *btn;
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10,100,300,60);
    [btn setTitle:@"終了" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnEndPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
    
    [self.view addSubview:img1_1];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"No01-45" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    img1_1.image = theImage;
 */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)btnEndPressed {
    [self dismissModalViewControllerAnimated:YES];
}

@end
