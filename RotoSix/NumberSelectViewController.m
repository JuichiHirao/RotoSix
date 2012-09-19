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
    CGPoint pos = [aTouch locationInView:self.view];
    
    if ([touches count] == 1) {
        for (UITouch *touch in touches) {
            CGPoint pos = [aTouch locationInView:[touch view]];
            pos = [[touch view] convertPoint:pos toView:nil];
            NSLog(@"%@", [NSString stringWithFormat:@"LayerSelectPanel touch x %f  y %f", pos.x, pos.y]);
        }
	}
    
    CALayer *layer = [selpanelView.layer hitTest:pos];
    NSLog(@"%@", [NSString stringWithFormat:@"layer %@", layer.name]);

    // y軸で回転のアニメーションをする
    //   iOS Core Frameworks Chapter 8.4.3 参照
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    anim.duration = 0.5f;
    anim.toValue = [NSNumber numberWithFloat:M_PI];
    [anim setValue:layer.name forKey:@"layername"];
    anim.delegate = self;
    
    CATransform3D pers = CATransform3DIdentity;
    pers.m34 = -1.0f/200.0f;
    pers = CATransform3DRotate(pers, 0, 0, 1, 0);
    layer.transform = pers;
    
    [layer addAnimation:anim forKey:@"rotation.y"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	// CAAnimationにKEY-VALUEで格納されているLayer名を取得する
	NSString *animName = [theAnimation valueForKey:@"layername"];
    NSLog(@"%@", [NSString stringWithFormat:@"animationDidStop animName %@", animName]);

    CALayer *findlayer = [self layerForName:animName];

    if (findlayer == nil) {
        NSLog(@"%@", [NSString stringWithFormat:@"not findlayer %@", animName]);
        return;
    }

    // LayerにKEY-VALUEで格納されている選択状態と逆の値を取得する
    NSString *chgSelected = [self getChangeSelected:[findlayer valueForKey:@"selected"]];
    [findlayer setValue:chgSelected forKey:@"selected"];

    // 取得した逆の値からイメージファイル名を取得、同画像を表示設定する
    findlayer.contents = (id)[UIImage imageNamed:[self getImageName:chgSelected layername:findlayer.name]].CGImage;
}

- (NSString *)getImageName:(NSString *)selected layername:(NSString *)layername
{
    NSString *strNo = [layername substringWithRange:NSMakeRange(0, 4)];
	// 未選択[0]の場合
	if ([selected isEqualToString:@"0"])
		return [NSString stringWithFormat:@"%@NoSel-45", strNo];
	
	return [NSString stringWithFormat:@"%@-45", strNo];
}

- (NSString *)getChangeSelected:(NSString *)selected
{
	// 未選択[0]の場合
	if ([selected isEqualToString:@"0"])
		return @"1";
	
	return @"0";
}

- (CALayer *)layerForName:(NSString *)name
{
	for(CALayer *layer in selpanelView.layer.sublayers) {
		if([[layer name] isEqualToString:@"NumberSelect"]) {
            if ([name isEqualToString:@"NumberSelect"]) {
                return layer;
            }
            for(CALayer *layerSub in layer.sublayers) {
                if([[layerSub name] isEqualToString:name]) {
                    return layerSub;
                }
            }
		}
		else if([[layer name] isEqualToString:name]) {
			return layer;
		}
	}
    
	return nil;
}

/* ビューから指定されたlayer.nameでレイヤーを探す
- (CALayer *)layerForName:(NSString *)name
{
	for(CALayer *layer in selpanelView.layer.sublayers) {
        NSLog(@"%@", [NSString stringWithFormat:@"selpanelView.layer.sublayers %@", [layer name]]);
		if([[layer name] isEqualToString:name]) {
			return layer;
		}
	}
    
	return nil;
}
 */

- (void)loadView {

    selpanelView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    selpanelView.opaque = YES;
    selpanelView.backgroundColor = [UIColor clearColor];
    
    LayerNumberSelect *selpanel = [LayerNumberSelect layer];
    //selpanel.bounds = CGRectMake(0, 0, 300, 340);
    selpanel.name = @"NumberSelect";
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
    CGFloat values[4] = {0.0, 0.0, 0.0, 0.0};
//    CGFloat values[4] = {1.0, 1.0, 1.0, 1.0};
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
