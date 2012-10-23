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

@synthesize buyNumbers;
@synthesize lblNotice;
@synthesize delegate = _delegate;

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

    NSLog(@"buyNumber %@", buyNumbers);
    
    CALayer *layer = [selpanelView.layer hitTest:pos];
    NSString *layerPrefix = [layer.name substringWithRange:NSMakeRange(0, 2)];
	// 未選択[0]の場合
	if (![layerPrefix isEqualToString:@"No"]) {
        NSLog(@"%@", [NSString stringWithFormat:@"layer [%@] Not No return", layer.name]);
		return;
    }

    NSString *selected = [layer valueForKey:@"selected"];
    NSLog(@"%@", [NSString stringWithFormat:@"layer %@ selected %@    selectNoCount %d", layer.name, selected, selectNoCount]);

    if ([selected isEqualToString:@"0"]) {
        if (selectNoCount >= 6) {
            // エラーメッセージは２秒で自動的に消す
            lblNotice.text = @"どれかを選択解除してから番号を選択して下さい";
            lblNotice.hidden = NO;
            [NSTimer scheduledTimerWithTimeInterval:2
                                             target:self
                                           selector:@selector(finishErrorMessage:)
                                           userInfo:nil
                                            repeats:NO];
            return;
        }
    }
    
    if ([selected isEqualToString:@"1"])
        selectNoCount--;
    else
        selectNoCount++;
    
    NSLog(@"%@", [NSString stringWithFormat:@"selectNoCount %d", selectNoCount]);

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

- (void)finishErrorMessage:(NSTimer *)timer
{
	lblNotice.hidden = YES;
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

    selpanelView = [[NumberSelectView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
//    selpanelView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
//    selpanelView = [[UIView alloc] initWithFrame:self.view.frame]; // 落ちる
    selpanelView.opaque = NO;
//    selpanelView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    selpanelView.backgroundColor = [UIColor clearColor];
    
    NSArray *arrBuyNo = [buyNumbers componentsSeparatedByString:@","];
    NSMutableArray *marrBuyNo = [[NSMutableArray alloc] init];
    
    for (int idx=0; idx < [arrBuyNo count]; idx++) {
        NSString *strNo = [arrBuyNo objectAtIndex:idx];
        [marrBuyNo addObject:[NSNumber numberWithInt:[strNo intValue]]];
    }
    
    selectNoCount = [arrBuyNo count];

    LayerNumberSelect *selpanel = [LayerNumberSelect layer];
    //selpanel.bounds = CGRectMake(0, 0, 300, 340);
    selpanel.name = @"NumberSelect";
    selpanel.frame = CGRectMake(0, 0, 300, 450);
    selpanel.position = CGPointMake(160, 270);
    selpanel.arrSelNo = marrBuyNo;

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
//    CGFloat values[4] = {0.0, 0.0, 0.0, 0.0}; // black
    CGFloat values[4] = {1.0, 1.0, 1.0, 1.0}; // white
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

    int viewCnt = 0;
    for (UIView *subView in [self.view subviews]) {
        viewCnt++;
        NSLog(@"%@", [NSString stringWithFormat:@"subView %d", viewCnt]);
    }

    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
//    selpanelView.opaque = NO;
//    selpanelView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];

	// Do any additional setup after loading the view.
    // 決定ボタン
	UIButton *btn;
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(230,430,70,30);
    //[btn setFont:[UIFont systemFontOfSize:14.0]];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btn setTitle:@"選択" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnEndPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(155,430,70,30);
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [btn setTitle:@"キャンセル" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnCancelPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
    
    lblNotice = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 420, 200.0, 10.0)];
//    lbl.backgroundColor = [UIColor clearColor];
    lblNotice.font = [UIFont systemFontOfSize:11.0];
//    lbl.textAlignment = UITextAlignmentRight;
    lblNotice.textColor = [UIColor blackColor];
    lblNotice.text = @"これはテストだよ、12345678903434535";
    lblNotice.hidden = YES;
//    lbl.opaque = 1.0;
    [self.view addSubview:lblNotice];
  
/*
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(15,420,70,30);
    [btn setFont:[UIFont systemFontOfSize:12.0]];
    [btn setTitle:@"元に戻す" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnEndPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
 */
//    [self.view addSubview:img1_1];
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
    NSString *selNo = [self getSelectNumber];
    
    if (selNo.length < 17) {
        lblNotice.text = @"6個の数字を選択して下さい";
        lblNotice.hidden = NO;
        [NSTimer scheduledTimerWithTimeInterval:2
                                         target:self
                                       selector:@selector(finishErrorMessage:)
                                       userInfo:nil
                                        repeats:NO];
        return;
    }

    [[self delegate] NumberSelectBtnEnd:self SelectNumber:selNo];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)btnCancelPressed {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)getSelectNumber
{
    NSString *selNum = @"";
	for(CALayer *layer in selpanelView.layer.sublayers) {
		if([[layer name] isEqualToString:@"NumberSelect"]) {
            for(CALayer *layerSub in layer.sublayers) {
                NSString *selected = [layerSub valueForKey:@"selected"];
                //NSLog(@"%@", [NSString stringWithFormat:@"getSelectNumber layername %@", [layerSub name]]);
                
                if ([selected isEqualToString:@"1"]) {
                    NSString *layerNo = [NSString stringWithFormat:@",%@", [layerSub.name substringWithRange:NSMakeRange(2, 2)]];
                    //NSLog(@"%@", [NSString stringWithFormat:@"getSelectNumber layerNo %@", layerNo]);
                    selNum = [NSString stringWithFormat:@"%@%@", selNum, layerNo];
                }
            }
		}
	}
    selNum = [selNum substringFromIndex:1];
    
    NSLog(@"%@", [NSString stringWithFormat:@"getSelectNumber %@", selNum]);
    
	return selNum;
}


@end
