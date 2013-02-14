//
//  SearchDataController.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/14.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Search.h"

@interface SearchDataController : NSObject

@property (nonatomic, copy, readwrite) NSMutableArray *list;

- (unsigned)countOfList;
- (Search *)objectInListAtIndex:(unsigned)theIndex;
- (void)removeObjectInListAtIndex:(unsigned)theIndex;
- (void)load;

@end
