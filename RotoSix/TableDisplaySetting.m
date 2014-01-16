//
//  TableDisplaySetting.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/08/29.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import "TableDisplaySetting.h"

@implementation UIView (FindFirstResponder)
- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}
@end

@implementation TableDisplaySetting

@synthesize delegate = _delegate;

/* Default
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0.980 alpha:1];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //---------
    // フキダシ
    
    //状態保存
    CGContextSaveGState(context);
    
    //Path作成
    CGRect bubbleRect = CGRectMake(15, 20, 170, 300);
    CGContextBubblePath(context, bubbleRect);
    CGPathRef bubblePath = CGContextCopyPath(context);
    
    //影
    CGContextSetShadow(context,CGSizeMake(0,1), 3);
    CGContextSetRGBFillColor(context, 0.97, 0.97, 0.97, 1);
    CGContextFillPath(context);
    CGContextSetShadow(context,CGSizeZero,0);
/*
    //背景
    CGContextAddPath(context, bubblePath);
    CGContextClip(context);
    CGFloat locations[] = {0.0, 0.2, 0.8, 1.0};
    CGFloat components[] = {
        0.506,0.722,0.990,1.0,
        0.652,0.849,0.996,1.0,
        0.652,0.849,0.996,1.0,
        0.803,0.945,1.000,1.0
    };
    size_t count = sizeof(components) / (sizeof(CGFloat)*4);
    CGPoint startPoint = bubbleRect.origin;
    CGPoint endPoint = startPoint;
    endPoint.y += bubbleRect.size.height;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
 */
    //Path解放
    CGPathRelease(bubblePath);
    
    //保存してた状態に戻す
    CGContextRestoreGState(context);
    
    //---------
    // 何か書く
/*
    CGRect textRect = CGRectMake(75, 45, 150, 60);
    NSString *text = @"こんにちは。\n吹き出し描いたよ。\nくちばし部分の構造は下の絵を見てね。";
    [[UIColor colorWithWhite:0.1 alpha:1] set];
    [text drawInRect:textRect withFont:[UIFont systemFontOfSize:12]];
 */
    UILabel *label = [[UILabel alloc] init];
    //label.backgroundColor = [UIColor clearColor];
    //label.font = [UIFont boldSystemFontOfSize:20];
    //label.shadowColor = [UIColor colorWithWhite:1.0 alpha:1];
    //label.shadowOffset = CGSizeMake(0, 1);
    //label.textColor = [UIColor colorWithRed:0.265 green:0.294 blue:0.367 alpha:1.000];
    //label.textAlignment = UITextAlignmentCenter;
    label.text = @"表示順";
    label.frame =CGRectMake(20, 30, 100, 30);
    [self addSubview:label];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"当選日の昇順" forState:UIControlStateNormal];
    [button titleLabel].textAlignment = UITextAlignmentCenter;
    [button addTarget:self action:@selector(testtest:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(20, 60, 160, 30);
    [self addSubview:button];

    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"当選日の降順" forState:UIControlStateNormal];
    [button titleLabel].textAlignment = UITextAlignmentCenter;
    [button addTarget:self action:@selector(testtest:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(20, 100, 160, 30);
    [self addSubview:button];

    label = [[UILabel alloc] init];
    label.text = @"表示内容";
    label.frame =CGRectMake(20, 130, 100, 30);
    [self addSubview:label];
    
    UIImage *bgOffImg = createImageFromUIColor([UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]);
    UIImage *bgOnImg = createImageFromUIColor([UIColor colorWithRed:0.878 green:1.0 blue:1.0 alpha:1.0]);

    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"全て" forState:UIControlStateNormal];
    [button titleLabel].textAlignment = UITextAlignmentCenter;
    //[button setBackgroundColor:[UIColor colorWithRed:0.878 green:1.0 blue:1.0 alpha:1.0]];
    [button setBackgroundImage:bgOffImg forState:UIControlStateNormal];
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted];
    [button setBackgroundImage:bgOnImg forState:UIControlStateNormal|UIControlStateSelected];
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted|UIControlStateSelected];
    [button addTarget:self action:@selector(testtest:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(20, 160, 160, 30);
    button.tag = 300;
    button.selected = YES;
    [self addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"当選" forState:UIControlStateNormal];
    [button titleLabel].textAlignment = UITextAlignmentCenter;
    [button setBackgroundImage:bgOffImg forState:UIControlStateNormal];
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted];
    [button setBackgroundImage:bgOnImg forState:UIControlStateNormal|UIControlStateSelected];
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted|UIControlStateSelected];

    [button addTarget:self action:@selector(testtest:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(20, 190, 160, 30);
    button.tag = 301;
    [self addSubview:button];

    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"抽選済み" forState:UIControlStateNormal];
    [button titleLabel].textAlignment = UITextAlignmentCenter;
    [button setBackgroundImage:bgOffImg forState:UIControlStateNormal];
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted];
    [button setBackgroundImage:bgOnImg forState:UIControlStateNormal|UIControlStateSelected];
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted|UIControlStateSelected];

    [button addTarget:self action:@selector(testtest:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(20, 220, 160, 30);
    button.tag = 302;
    [self addSubview:button];

    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"未抽選" forState:UIControlStateNormal];
    [button titleLabel].textAlignment = UITextAlignmentCenter;
    [button setBackgroundImage:bgOffImg forState:UIControlStateNormal];
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted];
    [button setBackgroundImage:bgOnImg forState:UIControlStateNormal|UIControlStateSelected];
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted|UIControlStateSelected];

    [button addTarget:self action:@selector(testtest:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(20, 250, 160, 30);
    button.tag = 303;
    [self addSubview:button];

/*
 button = [UIButton buttonWithType:UIButtonTypeCustom];
 [button setTitle:@"当選" forState:UIControlStateNormal];
 [button titleLabel].textAlignment = UITextAlignmentCenter;

    UIImage *bgOffImg = createImageFromUIColor([UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]);
    UIImage *bgOnImg = createImageFromUIColor([UIColor colorWithRed:0.878 green:1.0 blue:1.0 alpha:1.0]);

    // OFFの画像設定
    [button setBackgroundImage:bgOffImg forState:UIControlStateNormal];
    // OFFでボタンをタップ中の画像設定
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted];
    // ONの画像設定
    [button setBackgroundImage:bgOnImg forState:UIControlStateNormal|UIControlStateSelected];
    // ONでボタンをタップ中の画像設定
    [button setBackgroundImage:bgOffImg forState:UIControlStateHighlighted|UIControlStateSelected];
 
    [button addTarget:self action:@selector(testtest:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(20, 190, 160, 30);
    [self addSubview:button];
 */
}

UIImage *(^createImageFromUIColor)(UIColor *) = ^(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
};

- (void) testtest:(UIButton *)sender
{
    sender.selected=!sender.selected;
    NSString *label = [sender titleLabel].text;
    BOOL isDisplay = NO;
    if (sender.selected){
        // ON に変わった場合
        isDisplay = YES;
    }
    else{
        // OFF に変わった場合
        isDisplay = NO;
    }

    if (![label isEqualToString:@"全て"]) {
        bool isOne = NO, isTwo = NO, isThree = NO;
        UIButton *btn = (UIButton *)[self viewWithTag:301];
        isOne = btn.selected;
        btn = (UIButton *)[self viewWithTag:302];
        isTwo = btn.selected;
        btn = (UIButton *)[self viewWithTag:303];
        isThree = btn.selected;
        
        btn = (UIButton *)[self viewWithTag:300];
        
        if (isOne == NO && isTwo == NO && isThree == NO) {
            btn.selected = YES;
        }
        else {
            btn.selected = NO;
        }
    }
    else {
        UIButton *btn = (UIButton *)[self viewWithTag:301];
        btn.selected = NO;
        btn = (UIButton *)[self viewWithTag:302];
        btn.selected = NO;
        btn = (UIButton *)[self viewWithTag:303];
        btn.selected = NO;
    }

    [[self delegate] TableDisplaySettingSelected:label DisplayFlag:isDisplay];

    //NSLog(@"TESTTESTTEST %@", [btn titleLabel].text );
    return;
}

//角度→ラジアン変換
#if !defined(RADIANS)
#define RADIANS(D) (D * M_PI / 180)
#endif

//吹き出しを描く
void CGContextBubblePath(CGContextRef context, CGRect rect)
{
    CGFloat rad = 10;  //角の半径
    CGFloat qx = 10; // くちばしの長さ
    CGFloat qy = 20; // くちばしの高さ
    CGFloat cqy = 4; // 上くちばしカーブの基準点の高さ
    CGFloat lx = CGRectGetMinX(rect)+qx; //左
    CGFloat rx = CGRectGetMaxX(rect); //右
    CGFloat ty = CGRectGetMinY(rect); //上
    CGFloat by = CGRectGetMaxY(rect); //下
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, rx, ty+rad); //右上
    
    // CGRectMake(60.5, 40.5, 170, 70)
    // 東西南北の東が起点で、時計回り
    CGContextAddArc(context, rx+rad, ty+rad, rad, RADIANS(270), RADIANS(360), 0);   //右上のカーブ 1
    CGContextAddArc(context, rx+rad, by-rad, rad, RADIANS(0), RADIANS(90), 0);      //右下のカーブ 2
    CGContextAddArc(context, lx-rad, by-rad, rad, RADIANS(90), RADIANS(180), 0);    //左下のカーブ 3
    CGContextAddArc(context, lx-rad, ty+rad, rad, RADIANS(180), RADIANS(270), 0);   //左上のカーブ 4
    CGContextAddLineToPoint(context, lx+rad+10, ty);    // くちばしまで開始までの直線    5
    CGContextAddLineToPoint(context, lx+rad+15, ty-20); // くちばしの上端までの直線      6
    CGContextAddLineToPoint(context, lx+rad+25, ty);    // くちばし上端から下までの直線   7
    CGContextAddLineToPoint(context, rx+rad, ty);       // くちばし終了点から右上まで直線 8
    
    CGContextClosePath(context); //左上の点まで閉じる
}

//吹き出しを描く
void CGContextBubblePathOrg(CGContextRef context, CGRect rect)
{
    CGFloat rad = 10;  //角の半径
    CGFloat qx = 10; // くちばしの長さ
    CGFloat qy = 20; // くちばしの高さ
    CGFloat cqy = 4; // 上くちばしカーブの基準点の高さ
    CGFloat lx = CGRectGetMinX(rect)+qx; //左
    CGFloat rx = CGRectGetMaxX(rect); //右
    CGFloat ty = CGRectGetMinY(rect); //上
    CGFloat by = CGRectGetMaxY(rect); //下
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, lx, ty+rad); //左上
    CGContextAddArc(context, lx+rad, ty+rad, rad, RADIANS(180), RADIANS(270), 0); //左上のカーブ
    CGContextAddArc(context, rx-rad, ty+rad, rad, RADIANS(270), RADIANS(360), 0); //右上のカーブ
    CGContextAddArc(context, rx-rad, by-rad, rad, RADIANS(0), RADIANS(90), 0); //右下のカーブ
    CGContextAddArc(context, lx+rad, by-rad, rad, RADIANS(90), RADIANS(125), 0); //くちばしの付け根(下の凹み)
    CGContextAddQuadCurveToPoint(context, lx, by, lx-qx, by); //くちばしの先端
    CGContextAddQuadCurveToPoint(context, lx, by-cqy, lx, by-qy); //くちばしの付け根(上)
    
    CGContextClosePath(context); //左上の点まで閉じる
}


void CGContextBubblePathWithScale(CGContextRef context, CGRect rect, CGFloat scale)
{
    CGFloat rad = 10*scale;  //角の半径
    CGFloat qx = 10*scale; // くちばしの長さ
    CGFloat qy = 20*scale; // くちばしの高さ
    CGFloat cqy = 4*scale; // 上くちばしカーブの基準点の高さ
    CGFloat lx = CGRectGetMinX(rect)+qx; //左
    CGFloat rx = CGRectGetMaxX(rect); //右
    CGFloat ty = CGRectGetMinY(rect); //上
    CGFloat by = CGRectGetMaxY(rect); //下
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, lx, ty+rad); //左上
    CGContextAddArc(context, lx+rad, ty+rad, rad, RADIANS(180), RADIANS(270), 0); //左上のカーブ
    CGContextAddArc(context, rx-rad, ty+rad, rad, RADIANS(270), RADIANS(360), 0); //右上のカーブ
    CGContextAddArc(context, rx-rad, by-rad, rad, RADIANS(0), RADIANS(90), 0); //右下のカーブ
    CGContextAddArc(context, lx+rad, by-rad, rad, RADIANS(90), RADIANS(125), 0); //くちばしの付け根(下の凹み)
    CGContextAddQuadCurveToPoint(context, lx, by, lx-qx, by); //くちばしの先端
    CGContextAddQuadCurveToPoint(context, lx, by-cqy, lx, by-qy); //くちばしの付け根(上)
    
    CGContextClosePath(context); //左上の点まで閉じる
}


void CGContextBubblePathWithScaleOriginal(CGContextRef context, CGRect rect, CGFloat scale)
{
    CGFloat rad = 10*scale;  //角の半径
    CGFloat qx = 10*scale; // くちばしの長さ
    CGFloat qy = 20*scale; // くちばしの高さ
    CGFloat cqy = 4*scale; // 上くちばしカーブの基準点の高さ
    CGFloat lx = CGRectGetMinX(rect)+qx; //左
    CGFloat rx = CGRectGetMaxX(rect); //右
    CGFloat ty = CGRectGetMinY(rect); //上
    CGFloat by = CGRectGetMaxY(rect); //下
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, lx, ty+rad); //左上
    CGContextAddArc(context, lx+rad, ty+rad, rad, RADIANS(180), RADIANS(270), 0); //左上のカーブ
    CGContextAddArc(context, rx-rad, ty+rad, rad, RADIANS(270), RADIANS(360), 0); //右上のカーブ
    CGContextAddArc(context, rx-rad, by-rad, rad, RADIANS(0), RADIANS(90), 0); //右下のカーブ
    CGContextAddArc(context, lx+rad, by-rad, rad, RADIANS(90), RADIANS(125), 0); //くちばしの付け根(下の凹み)
    CGContextAddQuadCurveToPoint(context, lx, by, lx-qx, by); //くちばしの先端
    CGContextAddQuadCurveToPoint(context, lx, by-cqy, lx, by-qy); //くちばしの付け根(上)
    
    CGContextClosePath(context); //左上の点まで閉じる
}

void CGContextDrawAdditionalLine(CGContextRef context, CGRect rect, CGFloat scale)
{
    CGFloat rad = 10*scale;  //角の半径
    CGFloat qx = 10*scale; // くちばしの長さ
    CGFloat qy = 20*scale; // くちばしの高さ
    //CGFloat cqy = 4*scale; // 上くちばしカーブの基準点の高さ
    CGFloat lx = CGRectGetMinX(rect)+qx; //左
    CGFloat rx = CGRectGetMaxX(rect); //右
    CGFloat ty = CGRectGetMinY(rect); //上
    CGFloat by = CGRectGetMaxY(rect); //下
    
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 0.7);
    CGContextSetLineWidth(context, 1.5);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, lx, ty+rad);
    CGContextAddArc(context, lx+rad, ty+rad, rad, RADIANS(180), RADIANS(-180), 0);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, rx, ty+rad);
    CGContextAddArc(context, rx-rad, ty+rad, rad, RADIANS(0), RADIANS(360), 0);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, rx, by-rad);
    CGContextAddArc(context, rx-rad, by-rad, rad, RADIANS(0), RADIANS(360), 0);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, lx, by-rad);
    CGContextAddArc(context, lx+rad, by-rad, rad, RADIANS(180), RADIANS(-180), 0);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 0.7);
    CGContextMoveToPoint(context, lx+4.3*scale, by-1.8*scale);
    //CGContextAddLineToPoint(context, lx, by);
    CGContextAddLineToPoint(context, lx-qx, by);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 0.7);
    CGContextMoveToPoint(context, lx-qx, by);
    //CGContextAddLineToPoint(context, lx, by-cqy);
    CGContextAddLineToPoint(context, lx, by-qy);
    CGContextStrokePath(context);
}

@end
