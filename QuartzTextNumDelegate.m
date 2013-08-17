//
//  QuartzTextNumDelegate.m
//  QuartzTest
//
//  Created by Hirao Juuichi on 11/02/15.
//  Copyright 2011 self. All rights reserved.
//

#import "QuartzTextNumDelegate.h"


@implementation QuartzTextNumDelegate

@synthesize strNum;


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)myContext
{
	// CGContextShowTextAtPointの引数のchar*型に合わせる
    
    NSArray *arrData = [strNum componentsSeparatedByString:@","];

	const char *charNumOne = [arrData[0] UTF8String];
	const char *charNumTwo = [arrData[1] UTF8String];
	const char *charNumThree = [arrData[2] UTF8String];
	const char *charNumFour = [arrData[3] UTF8String];
	const char *charNumFive = [arrData[4] UTF8String];
	const char *charNumSix = [arrData[5] UTF8String];

    float w, h;
	CGRect contextRect = CGContextGetClipBoundingBox(myContext);
    w = contextRect.size.width;
    h = contextRect.size.height;
/*
    float one_w = w / 6;
	
	//CGContextTranslateCTM(myContext, 0, h);
	//CGContextScaleCTM(myContext, 1, -1);

	CGFloat fontSize = 18;
//   CGAffineTransform myTextTransform;
    CGContextSelectFont (myContext,
//						 "Avenir Next Ultra Light Italic",
//						 "Avenir Light Oblique",
						 "Avenir Next Italic",
//						 "Helvetica-Bold",
						 fontSize, kCGEncodingMacRoman);
//    CGContextSetCharacterSpacing (myContext, 10); // 文字間の幅
	
	// 箱内でセンタリングするために一度kCGTextInvisibleで仮描画してサイズを取得する
	//   ※ 幅は取得できるが、高さはフォントサイズから取得するので不要
	CGPoint start=CGContextGetTextPosition (myContext);
	CGContextSetTextDrawingMode (myContext,kCGTextInvisible);
	CGContextShowText (myContext,charNumOne,strlen(charNumOne));
	CGPoint end = CGContextGetTextPosition (myContext);
	float width = end.x - start.x;
 NSLog(@"%@", [NSString stringWithFormat:@"drawLayer w %f  h %f  one_w %f  width %f", w, h, one_w, width]);
	//NSLog(@"%@", [NSString stringWithFormat:@"height s[%f] e[%f]  h [%f](fontsize)", start.x, end.x, fontSize]);

	// テキスト描画時のモードを設定する
    CGContextSetTextDrawingMode (myContext, kCGTextFill);
	
    CGContextSetRGBFillColor (myContext, 0, 0, 0, .5);	// 文字の塗りつぶしの色
//    CGContextSetRGBStrokeColor (myContext, 0, 0, 1, 1); // 文字の外線の色
//    myTextTransform =  CGAffineTransformMakeRotation  (MyRadians(45)); // 8
//    CGContextSetTextMatrix (myContext, myTextTransform); // 9

//	CGContextShowTextAtPoint (myContext, 0, 0, charNum, strlen(charNum));
//	CGContextShowTextAtPoint (myContext, (w-width)/2, (h-fontSize)/2, charNum, strlen(charNum));
	CGContextShowTextAtPoint (myContext, 10.0, (h-fontSize)/2+2.3, charNumOne, strlen(charNumOne));
	CGContextShowTextAtPoint (myContext, 20.0, (h-fontSize)/2+2.3, charNumTwo, strlen(charNumTwo));
//	CGContextShowTextAtPoint (myContext, ((one_w*2)-width)/2, (h-fontSize)/2, charNum, strlen(charNum));
    */
    float totalWidth = 0;
    totalWidth = [self numShowText:arrData[0] beforeNumber:@"" inContext:myContext totalWidth:0 marginX:2 height:contextRect.size.height];
    totalWidth = [self numShowText:arrData[1] beforeNumber:arrData[0] inContext:myContext totalWidth:totalWidth marginX:5 height:contextRect.size.height];
    totalWidth = [self numShowText:arrData[2] beforeNumber:arrData[1] inContext:myContext totalWidth:totalWidth marginX:5 height:contextRect.size.height];
    totalWidth = [self numShowText:arrData[3] beforeNumber:arrData[2] inContext:myContext totalWidth:totalWidth marginX:5 height:contextRect.size.height];
    totalWidth = [self numShowText:arrData[4] beforeNumber:arrData[3] inContext:myContext totalWidth:totalWidth marginX:5 height:contextRect.size.height];
    totalWidth = [self numShowText:arrData[5] beforeNumber:arrData[4] inContext:myContext totalWidth:totalWidth marginX:5 height:contextRect.size.height];
}
- (float)numShowText:(NSString *)num beforeNumber:(NSString *)beforeNumber inContext:(CGContextRef)myContext totalWidth:(float)totalWidth marginX:(float)marginX height:(float)h {
    
    CGFloat fontSize = 18;
    int numData = [num intValue];
    int numBefore = [beforeNumber intValue];
    const char *charNum = [[NSString stringWithFormat:@"%d", numData] UTF8String];
//	const char *charNum = [num UTF8String];
    
    float margin = 0;
    if (numData >= 1 && numData <= 9) {
        fontSize = 18;
        if (numBefore >= 1 && numBefore <= 9)
            margin = marginX + 2;
        else
            margin = marginX;
    }
    else {
        fontSize = 18;
        
        if (numBefore >= 1 && numBefore <= 9)
            margin = marginX - 3;
        else
            margin = marginX;
    }
    
    CGContextSelectFont (myContext,
                         // "Avenir Next Ultra Light Italic",
                         // "Avenir Light Oblique",
						 "Avenir Next Italic",
                         // "Helvetica-Bold",
						 fontSize, kCGEncodingMacRoman);

    CGPoint start=CGContextGetTextPosition (myContext);
	CGContextSetTextDrawingMode (myContext,kCGTextInvisible);
	CGContextShowText (myContext,charNum,strlen(charNum));
	CGPoint end = CGContextGetTextPosition (myContext);
    
	float width = end.x - start.x; // フォントによる表示サイズ
    float posX = totalWidth + margin + (width / 2);

    CGContextSetTextDrawingMode (myContext, kCGTextFill);
	
    CGContextSetRGBFillColor (myContext, 0, 0, 0, .5);	// 文字の塗りつぶしの色

    CGContextShowTextAtPoint (myContext, posX, (h-fontSize)/2+2.3, charNum, strlen(charNum));
    float before = totalWidth;
    totalWidth = totalWidth + margin + width;
	NSLog(@"%@", [NSString stringWithFormat:@"drawLayer totalWidth %f -> %f  posX %f  width %f  margin %f  num[%@] befNum[%@]", before, totalWidth, posX, width, margin, num, beforeNumber]);
    
    return totalWidth;
}

@end
