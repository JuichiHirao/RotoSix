//
//  NumberSelectView.m
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/10/19.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import "NumberSelectView.h"

@implementation NumberSelectView

/* 自動生成ソース
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
 */

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = NO;
//		self.clearsContextBeforeDrawing = YES;
	}
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
