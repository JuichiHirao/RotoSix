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
@synthesize minSelNum;
@synthesize maxSelNum;
@synthesize lblNotice;
@synthesize delegate = _delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isAnimation == YES)
        return;
    
	UITouch *aTouch = [touches anyObject];
    CGPoint pos = [aTouch locationInView:self.view];

    // StoryBoardのMultiple Touchをチェックしないと複数の指の座標軸は取得できない なので必ずtouches countは1
    // http://ameblo.jp/xcc/entry-10230746253.html
    if ([touches count] == 1) {
        for (UITouch *touch in touches) {
            CGPoint pos = [aTouch locationInView:[touch view]];
            pos = [[touch view] convertPoint:pos toView:nil];
            NSLog(@"%@", [NSString stringWithFormat:@"LayerSelectPanel touch x %f  y %f", pos.x, pos.y]);
        }
	}
    else {
        NSLog(@"%@", [NSString stringWithFormat:@"LayerSelectPanel many finger touches x %f  y %f", pos.x, pos.y]);
    }

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
        if (selectNoCount >= maxSelNum) {
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
        
    NSLog(@"%@", [NSString stringWithFormat:@"selectNoCount %d", selectNoCount]);

    isAnimation = YES;
    // y軸で回転のアニメーションをする
    //   iOS Core Frameworks Chapter 8.4.3 参照
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    anim.duration = 0.3f;
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

    if ([chgSelected isEqualToString:@"1"])
        selectNoCount++;
    else
        selectNoCount--;

    if (selectNoCount > maxSelNum) {
        // エラーメッセージは２秒で自動的に消す
        lblNotice.text = @"どれかを選択解除してから番号を選択して下さい";
        lblNotice.hidden = NO;
        [NSTimer scheduledTimerWithTimeInterval:2
                                         target:self
                                       selector:@selector(finishErrorMessage:)
                                       userInfo:nil
                                        repeats:NO];
        selectNoCount--;
        return;
    }
    
    isAnimation = NO;

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

- (void)loadView {

    selpanelView = [[NumberSelectView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    selpanelView.opaque = NO;
    selpanelView.backgroundColor = [UIColor clearColor];
    
    NSArray *arrBuyNo = [buyNumbers componentsSeparatedByString:@","];
    NSMutableArray *marrBuyNo = [[NSMutableArray alloc] init];
    
    for (int idx=0; idx < [arrBuyNo count]; idx++) {
        NSString *strNo = [arrBuyNo objectAtIndex:idx];
        [marrBuyNo addObject:[NSNumber numberWithInt:[strNo intValue]]];
    }
    
    if (buyNumbers.length > 0) {
        selectNoCount = [arrBuyNo count];
    }
    // NSLog(@"loadView selectNoCount %d  buyNumbers [%@]", selectNoCount, buyNumbers);

    // 番号選択の最大数の設定
    if (maxSelNum <= 0)
        maxSelNum = 6;
    
    if (minSelNum <= 0)
        minSelNum = 6;

    LayerNumberSelect *selpanel = [LayerNumberSelect layer];
    //selpanel.bounds = CGRectMake(0, 0, 300, 340);
    selpanel.name = @"NumberSelect";
    CGFloat panelSizeY = 410;
    selpanel.frame = CGRectMake(0, 0, 300, panelSizeY);
    
    CGFloat posY = (selpanelView.bounds.size.height / 2 ) + (selpanelView.bounds.size.height / 2 - panelSizeY / 2);
    // NSLog(@"loadView posY [%f]   selpanelView.bounds.size.height [%f]", posY, selpanelView.bounds.size.height);
    selpanel.position = CGPointMake(160, posY); // posY <-- iPhone5 : 284(568/2) + 59(568/2-panelSizeY/2) =  343, other 240 + 15 = 255
    selpanel.arrSelNo = marrBuyNo;

    // 背景色の設定
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    // R, G, B, Alpha
    CGFloat values[4] = {1.0, 1.0, 1.0, 1.0}; // white (blackだと{0.0, 0.0, 0.0, 0.0})
    CGColorRef red = CGColorCreate(rgbColorspace, values);
    selpanel.backgroundColor = red;
    selpanel.opacity = YES;

    [selpanel setNeedsDisplay];
    [selpanelView.layer addSublayer:selpanel];
    
    CGFloat posBarY = selpanelView.bounds.size.height - panelSizeY - 44;
    UIToolbar *barTool = [ [ UIToolbar alloc ] initWithFrame:CGRectMake( 10, posBarY, 300, 44 ) ];
    
    UIBarButtonItem *barBtnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector( barBtnCancel: )];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector( barBtnDone: )];
    UIBarButtonItem *barBtnSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    barTool.items = [NSArray arrayWithObjects:barBtnCancel, barBtnSpacer, barBtnDone, nil];

    [selpanelView addSubview:barTool];

    self.view = selpanelView;

}

- (void)viewDidLoad
{
    int viewCnt = 0;
    for (UIView *subView in [self.view subviews]) {
        viewCnt++;
        NSLog(@"%@", [NSString stringWithFormat:@"subView %d", viewCnt]);
    }

    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    lblNotice = [[UILabel alloc] initWithFrame:CGRectMake(45 + 10 + 5, selpanelView.bounds.size.height - 45 - 10, 250.0, 50.0)];
    lblNotice.font = [UIFont systemFontOfSize:11.0];
    lblNotice.textAlignment = UITextAlignmentCenter;
    lblNotice.textColor = [UIColor blackColor];

    [self.view addSubview:lblNotice];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)barBtnDone:(id)sender {
    NSString *selNo = [self getSelectNumber];
    
    NSArray *arrBuySingleNo = [selNo componentsSeparatedByString:@","];
    
    if (!([arrBuySingleNo count] <= maxSelNum
          && [arrBuySingleNo count] >= minSelNum)) {
        if (minSelNum < maxSelNum) {
            lblNotice.text = [NSString stringWithFormat:@"%d〜%d個の数字を選択して下さい", minSelNum, maxSelNum];
        }
        else if (minSelNum == maxSelNum) {
            lblNotice.text = [NSString stringWithFormat:@"%d個の数字を選択して下さい", maxSelNum];
        }
        else {
            lblNotice.text = @"プログラムのバグです";
        }
        
        lblNotice.hidden = NO;
        [NSTimer scheduledTimerWithTimeInterval:2
                                         target:self
                                       selector:@selector(finishErrorMessage:)
                                       userInfo:nil
                                        repeats:NO];
        return;
    }
    
    [[self delegate] NumberSelectBtnEnd:self SelectNumber:selNo];
}

- (void)barBtnCancel:(id)sender
{
    [[self delegate] NumberSelectBtnEnd:self SelectNumber:@"Cancel"];
	return;
}

- (NSString *)getSelectNumber
{
    NSString *selNum = @"";
	for(CALayer *layer in selpanelView.layer.sublayers) {
		if([[layer name] isEqualToString:@"NumberSelect"]) {
            for(CALayer *layerSub in layer.sublayers) {
                NSString *selected = [layerSub valueForKey:@"selected"];
                NSLog(@"%@", [NSString stringWithFormat:@"getSelectNumber layername %@ selected [%@]", [layerSub name], selected]);
                
                if ([selected isEqualToString:@"1"]) {
                    NSString *layerNo = [NSString stringWithFormat:@",%@", [layerSub.name substringWithRange:NSMakeRange(2, 2)]];
                    //NSLog(@"%@", [NSString stringWithFormat:@"getSelectNumber layerNo %@", layerNo]);
                    selNum = [NSString stringWithFormat:@"%@%@", selNum, layerNo];
                }
            }
		}
	}
    
    if (selNum.length > 0)
        selNum = [selNum substringFromIndex:1];
    
    NSLog(@"%@", [NSString stringWithFormat:@"getSelectNumber %@", selNum]);
    
	return selNum;
}


@end
