//
//  ZCTradeInputView.m
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

#define ZCTradeInputViewNumCount 6

// 快速生成颜色
#define ZCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

typedef enum {
    ZCTradeInputViewButtonTypeWithCancle = 10000,
    ZCTradeInputViewButtonTypeWithOk = 20000,
}ZCTradeInputViewButtonType;

#import "ZCTradeInputView.h"
#import "ZCTradeKeyboard.h"
#import "NSString+ZG_Extension.h"

@interface ZCTradeInputView ()
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancleBtn;
@end

@implementation ZCTradeInputView

#pragma mark - LazyLoad

- (NSMutableArray *)nums
{
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 注册keyboard通知 */
        [self setupKeyboardNote];
        /** 添加子控件 */
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews
{
    /** 确定按钮 */
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:okBtn];
    self.okBtn = okBtn;
    [self.okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.okBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
//    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_up"] forState:UIControlStateNormal];
//    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_down"] forState:UIControlStateHighlighted];
    [self.okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn.tag = ZCTradeInputViewButtonTypeWithOk;
    
    /** 取消按钮 */
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize: 24.0];
//    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_up"] forState:UIControlStateNormal];
//    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_down"] forState:UIControlStateHighlighted];
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn.tag = ZCTradeInputViewButtonTypeWithCancle;
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote
{
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:ZCTradeKeyboardDeleteButtonClick object:nil];
    
    // 确定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok) name:ZCTradeKeyboardOkButtonClick object:nil];
    
    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:ZCTradeKeyboardNumberButtonClick object:nil];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 取消按钮 */
    self.cancleBtn.ZG_width = ZCScreenWidth * 0.409375;
    self.cancleBtn.ZG_height = ZCScreenWidth * 0.128125;
    self.cancleBtn.ZG_x = ZCScreenWidth * 0.05;
    self.cancleBtn.ZG_y = self.ZG_height - (ZCScreenWidth * 0.05 + self.cancleBtn.ZG_height)+10;
    
    /** 确定按钮 */
    self.okBtn.ZG_y = self.cancleBtn.ZG_y;
    self.okBtn.ZG_width = self.cancleBtn.ZG_width;
    self.okBtn.ZG_height = self.cancleBtn.ZG_height;
    self.okBtn.ZG_x = CGRectGetMaxX(self.cancleBtn.frame) + ZCScreenWidth * 0.025;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(self.okBtn.ZG_x, self.okBtn.ZG_y+15 , 1, 30);
    label.backgroundColor = ZCColor(230, 230, 230);
    [self addSubview:label];
}

#pragma mark - Private

// 删除
- (void)delete
{
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{
    if (self.nums.count >= ZCTradeInputViewNumCount) return;
    NSDictionary *userInfo = note.userInfo;
    NSNumber *numObj = userInfo[ZCTradeKeyboardNumberKey];
    [self.nums addObject:numObj];
    [self setNeedsDisplay];
}

// 确定
- (void)ok
{
    
}

// 按钮点击
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == ZCTradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:)]) {
            [self.delegate tradeInputView:self cancleBtnClick:btn];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewCancleButtonClick object:self];
    } else if (btn.tag == ZCTradeInputViewButtonTypeWithOk) {  // 确定按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:okBtnClick:)]) {
            [self.delegate tradeInputView:self okBtnClick:btn];
        }
        // 包装通知字典
        NSMutableString *pwd = [NSMutableString string];
        for (int i = 0; i < self.nums.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
            [pwd appendString:str];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[ZCTradeInputViewPwdKey] = pwd;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewOkButtonClick object:self userInfo:dict];
    } else {
        
    }
}

- (void)drawRect:(CGRect)rect
{
    // 画图
    UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    UIImage *field = [UIImage imageNamed:@"trade.bundle/password_in"];
    
    [bg drawInRect:rect];
    CGFloat x = ZCScreenWidth * 0.096875 * 0.55;
    CGFloat y = ZCScreenWidth * 0.40625 * 0.58;
    CGFloat w = ZCScreenWidth * 0.846875;
    CGFloat h = ZCScreenWidth * 0.121875;
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    // 画字
    NSString *title = @"请输入交易密码";
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:ZCScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (self.ZG_width - titleW) * 0.5;
    CGFloat titleY = ZCScreenWidth * 0.03125;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:ZCScreenWidth * 0.053125];
    attr[NSForegroundColorAttributeName] = ZCColor(102, 102, 102);
    
    [title drawInRect:titleRect withAttributes:attr];
    
    // 画字
    NSString *message = [NSString stringWithFormat: @"投资金额(元):%@",_money];
    
    
    CGSize MessageSize = [title sizeWithFont:[UIFont systemFontOfSize:ZCScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat messageW = MessageSize.width;
    CGFloat messageH = MessageSize.height;
    CGFloat messageX = (self.ZG_width - titleW) * 0.45;
    CGFloat messageY = ZCScreenWidth * 0.12025;
    CGRect messageRect = CGRectMake(0, messageY, self.ZG_width, messageH);
    
    NSMutableDictionary *messageAttr = [NSMutableDictionary dictionary];
    messageAttr[NSFontAttributeName] = [UIFont systemFontOfSize:ZCScreenWidth * 0.043125];
//    messageAttr[NSForegroundColorAttributeName] = ZCColor(102, 102, 102);
    messageAttr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
//    [message drawInRect:messageRect withAttributes:messageAttr];
    [message drawInRect:messageRect withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    
    // 画字
//    _money = @"999999";
    
//    CGSize moneySize = [title sizeWithFont:[UIFont systemFontOfSize:ZCScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    CGFloat moneyW = moneySize.width;
//    CGFloat moneyH = moneySize.height;
//    CGFloat moneyX = (self.width - messageW) * 0.9;
//    CGFloat moneyY = ZCScreenWidth * 0.12025;
//    CGRect moneyRect = CGRectMake(moneyX, moneyY, moneyW, moneyH);
//    
//    NSMutableDictionary *moneyAttr = [NSMutableDictionary dictionary];
//    moneyAttr[NSFontAttributeName] = [UIFont systemFontOfSize:ZCScreenWidth * 0.043125];
//    moneyAttr[NSForegroundColorAttributeName] = ZCColor(255, 69, 0);
    
//    [_money drawInRect:moneyRect withAttributes:moneyAttr];
    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = ZCScreenWidth * 0.04;
    CGFloat pointH = pointW;
    CGFloat pointY = ZCScreenWidth * 0.28;
    CGFloat pointX;
    CGFloat margin = ZCScreenWidth * 0.0484375;
    CGFloat padding = ZCScreenWidth * 0.049999125;
    for (int i = 0; i < self.nums.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
    // ok按钮状态
    BOOL statue = NO;
    if (self.nums.count == ZCTradeInputViewNumCount) {
        statue = YES;
    } else {
        statue = NO;
    }
    self.okBtn.enabled = statue;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end