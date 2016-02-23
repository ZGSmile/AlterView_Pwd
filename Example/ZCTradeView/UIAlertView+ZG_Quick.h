//
//  UIAlertView+ZG_Quick.h
//  HFCApp
//
//  Created by aaron.wu on 16/2/19.
//  Copyright © 2016年 chinapnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (ZG_Quick)
+ (void)showWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");

@end
