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
	int iMaxX = 6;				// X軸のマス目の最大数
	CGFloat fStartX = 25;		// X軸の開始位置（左マージン10 と 50の中心位置の25を足した値）
	CGFloat fStartY = 40;		// Y軸の開始位置（適当）
	CGFloat fPosY = fStartY;
	CGFloat fPosX = fStartX;
    
	///////////////////////
	// 番号のコントロールの表示

    id obj;
    int cnt = 0;
	CGFloat fRectSize = 45;                         // マス目の中のサイズ（X,Yは同じで正方形）
    CGFloat intervalY = 5, intervalX = 5;           // 番号の球の間隔
    CGFloat startMarginX = 1.8, startMarginY = 3;   // 先頭に空けるマージン
    
    for( int idx=1; idx <= 40; idx++)
    {
		fPosY = ((cnt / iMaxX) * fRectSize) + (((cnt / iMaxX) % 7) * intervalY) + (fRectSize / 2) + startMarginY;
        fPosX = ((cnt % iMaxX) * fRectSize) + (((idx -1) % iMaxX) * intervalX) + (fRectSize / 2) + startMarginX;
		//fPosX = (((cnt % iMaxX) + 1) * fRectSize) - fRectSize + fStartX;
		
        // 背景のグレイ色の丸画像の表示
		NSLog(@"%@", [NSString stringWithFormat:@"x %f  y %f", fPosX, fPosY]);
		CALayer *layerBg = [CALayer layer];
		layerBg.bounds = CGRectMake(0, 0, fRectSize, fRectSize);
		layerBg.name = [NSString stringWithFormat:@"Bg%@", obj];
		layerBg.position = CGPointMake(fPosX, fPosY);
		NSString *selected = @"0";
		//layerBg.contents = (id)[UIImage imageNamed:[self getImageName:selected]].CGImage;
        layerBg.contents = (id)[UIImage imageNamed:@"No01-45.png"].CGImage;
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
