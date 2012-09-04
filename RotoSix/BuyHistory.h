//
//  BuyHistory.h
//  RotoSix
//
//  Created by Juuichi Hirao on 2012/09/03.
//  Copyright (c) 2012年 Juuichi Hirao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyHistory : NSObject

@property (nonatomic, strong) NSString *BuySetOne;
@property (nonatomic, strong) NSString *BuySetTwo;
@property (nonatomic, strong) NSString *BuySetThree;
@property (nonatomic, strong) NSString *BuySetFour;
@property (nonatomic, strong) NSString *BuySetFive;
@property (nonatomic, strong) NSArray *characters;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSDate *date;

@end
