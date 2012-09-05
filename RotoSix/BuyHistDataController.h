//
//  BuyHistDataController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/04.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuyHistory;

@interface BuyHistDataController : NSObject

- (unsigned)countOfList;
- (BuyHistory *)objectInListAtIndex:(unsigned)theIndex;

@end
