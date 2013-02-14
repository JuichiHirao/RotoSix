//
//  Search.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2013/02/14.
//  Copyright (c) 2013年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search : NSObject

@property (nonatomic, assign) NSInteger dbId;
@property (nonatomic, strong) NSString *num_set;
@property (nonatomic, strong) NSDate *registDate;
@property (nonatomic, assign) NSInteger matchCount;

-(void)save;

@end
