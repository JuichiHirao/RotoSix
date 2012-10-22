//
//  LayerNumberSelect.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/10.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "LayerNumberSelect.h"

@implementation LayerNumberSelect

@synthesize arrSelNo;

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
	CGFloat fPosY = 0.0;
	CGFloat fPosX = 0.0;
    int cnt = 0;
/*  1列に6個表示の設定で表示（No43のみ8行目） */
	int iMaxX = 6;				// X軸のマス目の最大数
    int iMaxY = 8;              // Y軸のマス目の最大数（8行目は1個のみ表示）
	CGFloat fRectSize = 45;                         // マス目の中のサイズ（X,Yは同じで正方形）
    CGFloat intervalY = 5, intervalX = 5;           // 番号の球の間隔
    CGFloat startMarginX = 1.8, startMarginY = 3;   // 先頭に空けるマージン

/*
	int iMaxX = 8;				// X軸のマス目の最大数
	CGFloat fRectSize = 36;                         // マス目の中のサイズ（X,Yは同じで正方形）
    CGFloat intervalY = 2.5, intervalX = 2.5;           // 番号の球の間隔
    CGFloat startMarginX = 0.0, startMarginY = 3;   // 先頭に空けるマージン
 */
    
    int arrIdx = 0;
    for( int idx=1; idx <= 43; idx++)
    {
//		fPosY = ((cnt / iMaxX) * fRectSize) + (((cnt / iMaxX) % 7) * intervalY) + (fRectSize / 2) + startMarginY;
		fPosY = ((cnt / iMaxX) * fRectSize) + (((cnt / iMaxX) % iMaxY) * intervalY) + (fRectSize / 2) + startMarginY;
        fPosX = ((cnt % iMaxX) * fRectSize) + (((idx -1) % iMaxX) * intervalX) + (fRectSize / 2) + startMarginX;
		//fPosX = (((cnt % iMaxX) + 1) * fRectSize) - fRectSize + fStartX;
		
		//NSLog(@"%@", [NSString stringWithFormat:@"x %f  y %f", fPosX, fPosY]);
        
		CALayer *layerBg = [CALayer layer];
		layerBg.bounds = CGRectMake(0, 0, fRectSize, fRectSize);
		layerBg.name = [NSString stringWithFormat:@"No%02d", idx];
		layerBg.position = CGPointMake(fPosX, fPosY);
        
        int value = 0;
        if ([arrSelNo count] > arrIdx) {
            value = [[arrSelNo objectAtIndex:arrIdx] intValue];
        }
        
		NSString *selected = @"0";
        if (idx == value) {
            NSLog(@"%@", [NSString stringWithFormat:@"arrSelNo[%d] %d", arrIdx, value]);
            selected = @"1";
            arrIdx++;
        }
        
		[layerBg setValue:selected forKey:@"selected"];
        layerBg.contents = (id)[UIImage imageNamed:[self getImageName:selected SelectNo:idx]].CGImage;
        //layerBg.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"No%02dNoSel-45", idx]].CGImage;
        
		[self addSublayer:layerBg];
		
		cnt++;
	}
}

- (UIImage *)applyFiltersToImage:(UIImage *) image {
    UIImage *result;
    
    CIImage *ciImage = [CIImage imageWithCGImage:[image CGImage]];
    
    //CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    CIFilter *filter1 = [CIFilter filterWithName:@"CIExposureAdjust"];
    CIFilter *filter2 = [CIFilter filterWithName:@"CIColorInvert"];
    
    [filter1 setDefaults];
    [filter1 setValue:[NSNumber numberWithFloat:+2.0] forKey:@"inputEV"];
    
    [filter1 setValue:ciImage forKey:kCIInputImageKey];
    [filter2 setValue:filter1.outputImage forKey:kCIInputImageKey];
    
    CIImage *outputImage = filter2.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    result = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return result;
}

- (NSString *)getImageName:(NSString *)selected SelectNo:(int)selNo
{
	// 未選択[0]の場合
	if ([selected isEqualToString:@"0"])
		return [NSString stringWithFormat:@"No%02dNoSel-45", selNo];
	
	return [NSString stringWithFormat:@"No%02d-45", selNo];
}

@end
