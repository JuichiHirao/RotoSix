//
//  LayerNumberSelect.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/10.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "LayerNumberSelect.h"

@implementation LayerNumberSelect

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

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)theContext
- (void)drawInContext:(CGContextRef)theContext
{
    NSArray *itemsNum = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"15", @"18", @"22", @"26"
                         , @"27", @"28", @"29", @"30", @"31", @"32", @"32", @"32", @"32", @"32", @"32", @"32", @"32", @"32", nil];
	//NSArray *itemsNum = [[NSArray alloc] initWithObjects:@"1", @"3", @"8", nil];
    
    NSEnumerator *enumNum = [itemsNum objectEnumerator];
	id obj;
	
	int cnt = 0;
	int iMaxX = 6;				// X軸のマス目の最大数
	CGFloat fRectSize = 50;		// マス目の中のサイズ（X,Yは同じで正方形）
	CGFloat fStartX = 25;		// X軸の開始位置（左マージン10 と 50の中心位置の25を足した値）
	CGFloat fStartY = 40;		// Y軸の開始位置（適当）
	CGFloat fPosY = fStartY;
	CGFloat fPosX = fStartX;
    
    NSLog(@"%@", [NSString stringWithFormat:@"drawInContext %@", @"test"]);
    
    CALayer *bgPanel = [CALayer layer];
    bgPanel.bounds = CGRectMake(0, 0, 320, 360);
    bgPanel.position = CGPointMake(0, 10);
    //bgPanel.contents = (id)[UIImage imageNamed:@"PartnerSelectPanel.png"].CGImage;
    
    [self addSublayer:bgPanel];
    //    panel.bounds = CGRectMake(0, 0, 300, 340);
    //    panel.position = CGPointMake(160, 290);
    //    panel.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"PartnerSelectPanel.png"]].CGColor;
    
	///////////////////////
	// 番号のコントロールの表示
	while (obj = [enumNum nextObject])
	{
		fPosY = (((cnt / iMaxX) + 1) * fRectSize) + fStartY;
		fPosX = (((cnt % iMaxX) + 1) * fRectSize) - fRectSize + fStartX;
		
        // 背景のグレイ色の丸画像の表示
		NSLog(@"%@", [NSString stringWithFormat:@"x %f  y %f", fPosX, fPosY]);
		CALayer *layerBg = [CALayer layer];
		layerBg.bounds = CGRectMake(0, 0, fRectSize, fRectSize);
		layerBg.name = [NSString stringWithFormat:@"Bg%@", obj];
		layerBg.position = CGPointMake(fPosX, fPosY);
		NSString *selected = @"0";
		//layerBg.contents = (id)[UIImage imageNamed:[self getImageName:selected]].CGImage;
        layerBg.contents = (id)[UIImage imageNamed:@"BallIcon-48.png"].CGImage;
		[layerBg setValue:selected forKey:@"selected"];
        // [self.layer addSublayer:layerBg];
		[self addSublayer:layerBg];
		
		CALayer *layerNum = [CALayer layer];
		layerNum.needsDisplayOnBoundsChange = YES;
		layerNum.bounds = CGRectMake(0, 0, fRectSize, fRectSize);
		layerNum.name = [NSString stringWithFormat:@"Num%@", obj];
		layerNum.position = CGPointMake(fPosX, fPosY);
//		_layerDelegate = [[QuartzTextNumDelegate alloc] init];
//		_layerDelegate.strNum = obj;
//		layerNum.delegate = _layerDelegate;
		
        // [self.layer addSublayer:layerNum];
		[self addSublayer:layerNum];
		cnt++;
	}
}

- (NSString *)getImageName:(NSString *)selected
{
	// 未選択[0]の場合
	if ([selected isEqualToString:@"0"])
		return @"BallIcon-48.png";
	
	return @"circle_green.png";
}

@end
