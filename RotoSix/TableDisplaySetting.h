//
//  TableDisplaySetting.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/08/29.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableDisplaySettingEnd;

@interface TableDisplaySetting : UIView
{
    id <TableDisplaySettingEnd> delegate;

}

@property (weak, nonatomic) id <TableDisplaySettingEnd> delegate;

@end

@protocol TableDisplaySettingEnd <NSObject>

- (void)TableDisplaySettingSelected:(NSString *)buttonTitleLabel DisplayFlag:(BOOL)isDisplay;

@end
