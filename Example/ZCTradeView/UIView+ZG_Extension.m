//
//  UIView+ZG_Extension.m
//  HFCApp
//
//  Created by aaron.wu on 16/2/19.
//  Copyright © 2016年 chinapnr. All rights reserved.
//

// 最大的尺寸
#define ZCMAXSize CGSizeMake(MAXFLOAT, MAXFLOAT)

// 快速实例
#define Object(Class) [[Class alloc] init];

#import "UIView+ZG_Extension.h"

@implementation UIView (ZG_Extension)

- (void)setZG_x:(CGFloat)ZG_x
{
    CGRect frame = self.frame;
    frame.origin.x = ZG_x;
    self.frame = frame;
}

- (CGFloat)ZG_x
{
    return self.frame.origin.x;
}

- (void)setZG_y:(CGFloat)ZG_y
{
    CGRect frame = self.frame;
    frame.origin.y = ZG_y;
    self.frame = frame;
}

- (CGFloat)ZG_y
{
    return self.frame.origin.y;
}

- (void)setZG_width:(CGFloat)ZG_width
{
    CGRect frame = self.frame;
    frame.size.width = ZG_width;
    self.frame = frame;
}

- (CGFloat)ZG_width
{
    return self.frame.size.width;
}

- (void)setZG_height:(CGFloat)ZG_height
{
    CGRect frame = self.frame;
    frame.size.height = ZG_height;
    self.frame = frame;
}

- (CGFloat)ZG_height
{
    return self.frame.size.height;
}

- (void)setZG_size:(CGSize)ZG_size
{
    CGRect frame = self.frame;
    frame.size = ZG_size;
    self.frame = frame;
}

- (CGSize)ZG_size
{
    return self.frame.size;
}

- (void)setZG_centerX:(CGFloat)ZG_centerX
{
    CGPoint center = self.center;
    center.x = ZG_centerX;
    self.center = center;
}

- (CGFloat)ZG_centerX
{
    return self.center.x;
}

- (void)setZG_centerY:(CGFloat)ZG_centerY
{
    CGPoint center = self.center;
    center.y = ZG_centerY;
    self.center = center;
}

- (CGFloat)ZG_centerY
{
    return self.center.y;
}

/** 水平居中 */
- (void)alignHorizontal
{
    self.ZG_x = (self.superview.ZG_width - self.ZG_width) * 0.5;
}

/** 垂直居中 */
- (void)alignVertical
{
    self.ZG_y = (self.superview.ZG_height - self.ZG_height) * 0.5;
}

/** 添加子控件 */
- (void)addSubview:(Class)class propertyName:(NSString *)propertyName
{
    id subView = Object(class);
    if ([self isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)self;
        [cell.contentView addSubview:subView];
    } else {
        [self addSubview:subView];
    }
    [self setValue:subView forKeyPath:propertyName];
}

@end
