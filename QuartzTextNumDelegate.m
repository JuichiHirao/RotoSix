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
	//NSLog(@"%@", [NSString stringWithFormat:@"drawLayer strNum %@", strNum]);
    
	// CGContextShowTextAtPointの引数のchar*型に合わせる
    NSArray *arrData = [strNum componentsSeparatedByString:@","];

	CGRect contextRect = CGContextGetClipBoundingBox(myContext);

    if (strNum.length > 0 && arrData.count == 6) {
        [self numShowText:arrData[0] inContext:myContext startPosX:3 height:contextRect.size.height];
        [self numShowText:arrData[1] inContext:myContext startPosX:29 height:contextRect.size.height];
        [self numShowText:arrData[2] inContext:myContext startPosX:55 height:contextRect.size.height];
        [self numShowText:arrData[3] inContext:myContext startPosX:81 height:contextRect.size.height];
        [self numShowText:arrData[4] inContext:myContext startPosX:107 height:contextRect.size.height];
        [self numShowText:arrData[5] inContext:myContext startPosX:133 height:contextRect.size.height];
    }
    else {
        // http://d.hatena.ne.jp/hhidemi/20100929/1285733273
        UIGraphicsPushContext(myContext);
        UIFont *font = [UIFont systemFontOfSize:16];
        NSString *string = @"コピー情報無し";
        
        CGContextTranslateCTM(myContext, 0, contextRect.size.height);
        CGContextScaleCTM(myContext, 1, -1);

        CGColorRef fontColor = [[UIColor grayColor]CGColor];
        CGContextSetFillColorWithColor(myContext, fontColor);
        
        [string drawAtPoint:CGPointMake(25,2) withFont:font];
        UIGraphicsPopContext();
    }
}
- (void)numShowText:(NSString *)num inContext:(CGContextRef)myContext startPosX:(float)startPosX height:(float)h {
    
    CGFloat fontSize = 16;
    int numData = [num intValue];
    const char *charNum = [[NSString stringWithFormat:@"%d", numData] UTF8String];

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
    
    // １文字の場合は21の中の真ん中に数字が表示されるように計算
    //   startPosX ＋ ２文字の場合のwidthの21の半分10.5 ー （文字の幅 ／ 2）
    float posX = startPosX + 10.5 - (width / 2);

    CGContextSetTextDrawingMode (myContext, kCGTextFill);
	
    CGContextSetRGBFillColor (myContext, 0, 0, 0, .5);	// 文字の塗りつぶしの色

    CGContextShowTextAtPoint (myContext, posX, (h-fontSize)/2+1, charNum, strlen(charNum));

	//NSLog(@"%@", [NSString stringWithFormat:@"drawLayer startPosX %f  posX %f  width %f  num[%@] ", startPosX, posX, width, num]);
    
    return;
}

@end
