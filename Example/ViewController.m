//
//  ViewController.m
//  Example
//
//  Created by 塔利班 on 15/5/22.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

#import "ViewController.h"
#import "ZCTradeView.h"

@interface ViewController ()<ZCTradeViewDelegate>

@end

@implementation ViewController

- (IBAction)showTradeView:(id)sender
{
    ZCTradeView *tradeView = [[ZCTradeView alloc] init];
    tradeView.moneyNum = @"250";
    [tradeView withMessage];
    
    tradeView.delegate = self;
    [tradeView show];
}


-(NSString *)finish:(NSString *)pwd{
    NSLog(@"-----%@",pwd);
    return pwd;
}

@end