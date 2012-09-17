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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", @"LayerSelectPanel touch x %f  y %f");
	UITouch *aTouch = [touches anyObject];
    if ([touches count] == 1) {
        for (UITouch *touch in touches) {
            CGPoint pos = [aTouch locationInView:[touch view]];
            pos = [[touch view] convertPoint:pos toView:nil];
            NSLog(@"%@", [NSString stringWithFormat:@"LayerSelectPanel touch x %f  y %f", pos.x, pos.y]);
        }
	}
}

- (void)loadView {
//    UIView *modalView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    modalView.opaque = NO;
//    modalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

    selpanelView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    selpanelView.opaque = NO;
    selpanelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    LayerNumberSelect *selpanel = [LayerNumberSelect layer];
    //selpanel.bounds = CGRectMake(0, 0, 300, 340);
    selpanel.frame = CGRectMake(0, 0, 300, 450);
    selpanel.position = CGPointMake(160, 270);

/*  背景画像（表示されない）
    CALayer *bgLayer = [CALayer layer];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"NumberSelectBackground" ofType:@"png"];
    UIImage *bgImage = [UIImage imageWithContentsOfFile:imagePath];
    CGRect  bgFrame = CGRectMake(0.0, 0.0, 300, 460);
    selpanel.contents = (id)bgImage.CGImage;
    selpanel.frame = bgFrame;
    
    [selpanelView.layer addSublayer:bgLayer];
 */
    
    // 背景色の設定
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    // R, G, B, Alpha
    CGFloat values[4] = {1.0, 1.0, 1.0, 1.0};
    CGColorRef red = CGColorCreate(rgbColorspace, values);
    selpanel.backgroundColor = red;
    selpanel.opacity = YES;

    [selpanel setNeedsDisplay];
    [selpanelView.layer addSublayer:selpanel];
    
//    [self.view clearsContextBeforeDrawing];
    self.view = selpanelView;
}
- (void)viewDidLoad
{
    UIImageView *img1_1, *img1_2, *img1_3, *img1_4, *img1_5, *img1_6;

/*
    img1_1 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 5.0, 45.0, 45.0)];
    [super viewDidLoad];
    LayerNumberSelect *selpanel = [LayerNumberSelect layer];
    selpanel.bounds = CGRectMake(0, 0, 300, 340);
    selpanel.position = CGPointMake(0, 10);
    
    selpanelView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    [selpanelView.layer addSublayer:selpanel];
    
//    [self.view clearsContextBeforeDrawing];
    [self.view addSubview:selpanelView];
  */

	// Do any additional setup after loading the view.
    // 決定ボタン
	UIButton *btn;
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(230,420,70,30);
    [btn setFont:[UIFont systemFontOfSize:14.0]];
    [btn setTitle:@"選択" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnEndPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(155,420,70,30);
    [btn setFont:[UIFont systemFontOfSize:12.0]];
    [btn setTitle:@"キャンセル" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnEndPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(15,420,70,30);
    [btn setFont:[UIFont systemFontOfSize:12.0]];
    [btn setTitle:@"元に戻す" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnEndPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];

//    [self.view addSubview:img1_1];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"No01-45" ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:imagePath];
    
    img1_1.image = theImage;
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
