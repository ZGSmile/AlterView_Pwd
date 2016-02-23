//
//  UIAlertView+ZG_Quick.m
//  HFCApp
//
//  Created by aaron.wu on 16/2/19.
//  Copyright © 2016年 chinapnr. All rights reserved.
//

#import "UIAlertView+ZG_Quick.h"

@implementation UIAlertView (ZG_Quick)

+ (void)showWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alertView show];
}

@end
